class Plan
  BAIO_FOR_EXPERT = %w(vip_package pro_package).freeze
  DURATION_NAME = {
    1 => '1 month',
    12 => '1 year'
  }.freeze
  VALID_DURATIONS = DURATION_NAME.keys.freeze # months

  PLANS = {
    free: OpenStruct.new({
      active: false,
      upgrade_rating: 0,
      name: 'FREE',
      price_cents: {
        1 => 0,
        12 => 0,
      },
      message_limit: 3,         # Can create and send 3 Videomails
      free_template_limit: 3,   # Can use 3 free templates
      video_playlist: false,
      premium_templates: false,
      video_duration_limit: 30 * 1000,  # Can use 30 secs duration video
      statistics: false
    }),
    pro: OpenStruct.new({
      active: true,        # Can be purchased
      upgrade_rating: 10,  # Upgradable to plan with higher value
      name: 'PRO',         # Plan name
      price_cents: {       # Price per duration
        1 => 490,
        12 => 4900
      },
      message_limit: nil,       # Can send unlimited videomails
      free_template_limit: 30,  # Can use 30 free templates
      video_playlist: true,     # Can create video playlists
      premium_templates: true,  # Can use free premium templates
      video_duration_limit: nil,  # Can use unlimited duration video
      statistics: true
    }),
    expert: OpenStruct.new({
      active: true,
      upgrade_rating: 100,
      name: 'EXPERT',
      price_cents: {
        1 => 649,
        12 => 6200
      },
      message_limit: nil,       # Can send unlimited videomails
      free_template_limit: nil, # Can use all free templates
      video_playlist: true,     # Can create video playlists
      premium_templates: true,  # Can use free premium templates
      video_duration_limit: nil,  # Can use unlimited duration video
      statistics: true
    })
  }.with_indifferent_access.freeze

  def self.by_plan_type(plan_type)
    PLANS[plan_type]
  end

  def self.free_plan
    by_plan_type(:free)
  end

  def self.free_plan_duration
    -1
  end

  def self.pro_plan
    by_plan_type(:pro)
  end

  def self.expert_plan
    by_plan_type(:expert)
  end

end
