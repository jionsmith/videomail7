class Account < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :authentications, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :used_templates, class_name: 'Template', through: :messages, source: :template
  has_many :authored_templates, class_name: 'Template', foreign_key: :account_id, inverse_of: :author_account
  has_many :playlists, dependent: :destroy

  has_and_belongs_to_many :products
  has_and_belongs_to_many :templates

  has_many :orders, dependent: :destroy

  # AddressBook
  # has_many :account_contacts, :class_name => 'Addressbook::AccountContact', as: :owner
  # has_many :account_contact_groups, :class_name => 'Addressbook::AccountContactGroup', as: :owner

  after_create :apply_referrer_code

  def messages_in_status(status)
    if status == 'all' || status.blank?
      @messages = self.messages
    elsif status == 'trash'
      @messages = self.messages.only_deleted
    else
      @messages = self.messages.by_status(status)
    end
  end

  def available_templates
    all_templates = if can_use_premium_templates?
      Template.from("(#{Template.free_templates.to_sql} UNION #{self.templates.to_sql.sub('$1', to_param)}) AS templates").distinct
    else
      Template.from("(#{Template.free_templates.not_premium_templates.to_sql} UNION #{self.templates.to_sql.sub('$1', to_param)}) AS templates").distinct
    end

    all_templates.enabled_templates.by_title

    # template_ids = Template.pluck(:id) + self.templates.pluck(:id)
    # template_ids.uniq!
    # Template.where(id: template_ids)
  end

  def my_templates
    category = Category.default_category
    templates = Template.from("(#{category.templates.to_sql.sub('$1', category.to_param)} UNION #{self.templates.to_sql.sub('$1', to_param)}) AS templates").distinct
    templates.enabled_templates.by_title
  end

  def available_categories
    return [] if self.templates.enabled_templates.blank?
    category_ids = self.templates.enabled_templates.collect do |t|
      t.categories.pluck(:id)
    end
    category_ids.flatten.uniq
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.from_omniauth(auth)
    account = Authentication.where(provider: auth[:provider], uid: auth[:uid]).first.try(:account) || create_from_omniauth(auth)

    if auth.info
      if account.promotion_code != auth.info.promotion_code
        account.update promotion_code: auth.info.promotion_code
      end

      if auth.provider.to_s == 'bonofa'
        if Plan::BAIO_FOR_EXPERT.include? auth.info.baio_package
          # Upgrade
          unless account.active_order.try :baio_order?
            Order.create_baio_order(account)
          end
        elsif account.active_order.try :baio_order?
          # Downgrade
          account.active_order.cancelled!

          # Restore inactive
          account.restore_unexpired_order
        end
      end
    end

    account
  end

  def apply_referrer_code
    if referrer_code.present? && promotion_code != referrer_code
      response = RestClient.get "https://shop.bonofa.com/api/v1/promo_code/#{referrer_code.strip}"
      json = MultiJson.load(response)
      if json['code'] == 'OK'
        update bonofa_partner_account_id: json['account_id']
      end
    end
  rescue => ex
    Rails.logger.error ex.inspect
    Rails.logger.error ex.backtrace.join("\n")
  end

  def self.create_from_omniauth(auth)
    unless (account = Account.find_by_email(auth['info']['email']))
      password = Devise.friendly_token[0,20]
      account = Account.create(
        email:                  auth.info.email,
        first_name:             auth.info.first_name,
        last_name:              auth.info.last_name,
        referrer_code:          auth.referrer_code,
        password:               password,
        password_confirmation:  password,
      )
    end

    account.authentications.build(
      provider: auth['provider'],
      uid:  auth['uid'],
      token: auth['credentials']['token']
    )
    account.save
    account
  end

  def restore_unexpired_order
    orders.not_baio.inactive.most_recent.each do |recent|
      if recent.expired_at && recent.expired_at > Date.today
        recent.active!
        return
      end
    end
  end

  def active_order
    orders.active.first
  end

  def current_plan
    active_order.try(:plan) || Plan.free_plan
  end

  def current_duration
    active_order.try(:plan_duration) || Plan.free_plan_duration
  end

  def check_upgrade_plan!(new_plan, new_duration)
    new_duration = new_duration.to_i

    if active_order.try :baio_order?
      raise "Can't upgrade plan"
    end

    unless new_plan.try :active
      raise 'Bad or inactive plan'
    end

    if new_plan.upgrade_rating < current_plan.upgrade_rating
      raise "Can't downgrade plan"
    end

    unless Plan::VALID_DURATIONS.include?(new_duration)
      raise 'Bad plan duration'
    end

    if new_plan == current_plan
      if new_duration == current_duration
        raise 'Plan/duration already active'
      elsif new_duration < current_duration
        raise "Can't downgrade plan duration"
      end
    end
  end

  def upgrade_plan_status(new_plan, new_duration)
    if active_order.try :baio_order?
      :cannot_upgrade
    elsif new_plan == current_plan && new_duration == current_duration
      :current
    elsif new_plan == current_plan && new_duration < current_duration
      :cannot_upgrade
    elsif !new_plan.active || new_plan.upgrade_rating < current_plan.upgrade_rating
      :cannot_upgrade
    else
      :can_upgrade
    end
  end

  def can_create_message?
    current_plan.message_limit.nil? || current_plan.message_limit > messages.count
  end

  def can_use_video_playlist?
    !!current_plan.video_playlist
  end

  def can_use_premium_templates?
    !!current_plan.premium_templates
  end

  def can_use_video_duration_of?(duration)
    current_plan.video_duration_limit.blank? || current_plan.video_duration_limit > duration
  end

  def can_see_statistics?
    current_plan.statistics
  end

  def can_use_template?(template, for_replace = false)
    # Default ones
    return true if template.is_default?
    # Purchased
    return true if templates.include?(template)
    # Free?
    return false unless template.is_free?

    if current_plan.free_template_limit.nil?
      # No limit
      !template.premium_template? || can_use_premium_templates?
    else
      used_free_templates = used_templates.free_templates.distinct
      if used_free_templates.include?(template)
        # Already used
        true
      else
        if (for_replace && used_free_templates.count <= current_plan.free_template_limit) || # +1 to replace used
           (used_free_templates.count < current_plan.free_template_limit)
          !template.premium_template? || can_use_premium_templates?
        else
          false
        end
      end
    end
  end

  def can_use_product?(product)
    limit = self.current_plan.free_template_limit || 99999
    return false if product.productable.premium_template == true && current_plan == Plan.free_plan
    return !self.has_product?(product) && self.templates.free_templates.count <= limit if product.is_free?
    return true
  end

  def has_product?(product)
    if product.is_package?
      return self.products.include?(product)
    elsif product.is_template?
      return self.templates.include?(product.parent_object)
    end
    false
  end

  def add_product(product)
    return false if !can_use_product?(product)

    self.products << product
    if product.is_template?
      self.templates << product.parent_object
    elsif product.is_package?
      product.parent_object.templates.each do |template|
        self.templates << template unless self.templates.include?(template)
      end
    end
    self.save
  end

end
