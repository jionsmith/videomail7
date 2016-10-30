require 'rails_helper'

RSpec.describe Account, type: :model do
  subject do
    create :account
  end

  it 'subject' do
    pp subject
    expect(subject).to be_a described_class
  end

  describe '#current_plan' do
    it 'free' do
      expect(subject.current_plan).to eq Plan.free_plan
    end

    it 'inactive' do
      s1 = create :order, account: subject, status: :inactive
      expect(subject.current_plan).to eq Plan.free_plan
    end

    it 'active' do
      s1 = create :order, account: subject, status: :active
      expect(subject.current_plan).to eq s1.plan
    end
  end

  it '#apply_referrer_code' do
    a1 = create :account, referrer_code: 'bonofa'
    expect(a1.bonofa_partner_account_id).to eq 1
  end

  describe '.from_omniauth' do
    let(:info) { OpenStruct.new baio_package: Plan::BAIO_FOR_EXPERT.first }
    let(:auth) { OpenStruct.new provider: 'bonofa', uid: '1', info: info }

    before(:each) {
      subject.authentications.create! provider: 'bonofa', uid:  '1', token: '111'
    }

    it 'baio partner get expert plan' do
      a1 = Account.from_omniauth(auth) # upgrade
      expect(subject).to eq a1
      expect(subject.current_plan).to eq Plan.expert_plan

      info.baio_package = 'bad'
      Account.from_omniauth(auth) # downgrade
      expect(subject.current_plan).to eq Plan.free_plan
    end

    it 'not baio partner downgrade' do
      subject.orders.create! plan_type: 'pro', plan_duration: 12, status: :active, payment_method: 'inatec', expired_at: 1.years.since
      expect(subject.current_plan).to eq Plan.pro_plan

      Order.create_baio_order(subject)
      expect(subject.current_plan).to eq Plan.expert_plan

      info.baio_package = 'bad'
      Account.from_omniauth(auth) # downgrade
      expect(subject.current_plan).to eq Plan.pro_plan
    end
  end

  it '#restore_unexpired_order' do
    a1 = create :account
    o0 = create :order, account: a1, expired_at: 2.days.ago, status: :inactive
    o1 = create :order, account: a1, expired_at: 2.days.since, status: :inactive
    o2 = create :order, account: a1, expired_at: 3.days.ago, status: :inactive

    a1.restore_unexpired_order

    expect(a1.active_order).to eq o1
  end

  it '.check_upgrade_plan!' do
    subject.orders.create! plan_type: 'pro', plan_duration: 12, status: :active, payment_method: 'inatec', expired_at: 1.years.since
    expect(subject.current_plan).to eq Plan.pro_plan
    expect(subject.current_duration).to eq 12

    expect { subject.check_upgrade_plan!(Plan.pro_plan, 1) }.to raise_error
    expect { subject.check_upgrade_plan!(Plan.pro_plan, 12) }.to raise_error

    expect { subject.check_upgrade_plan!(Plan.expert_plan, 1) }.to_not raise_error
    expect { subject.check_upgrade_plan!(Plan.expert_plan, 12) }.to_not raise_error

    subject.orders.destroy_all
    subject.orders.create! plan_type: 'pro', plan_duration: 1, status: :active, payment_method: 'inatec', expired_at: 1.years.since

    expect { subject.check_upgrade_plan!(Plan.pro_plan, 1) }.to raise_error
    expect { subject.check_upgrade_plan!(Plan.pro_plan, 12) }.to_not raise_error
  end

  it '#can_use_template?' do
    p1 = create :template_product, price_cents: 0
    p2 = create :template_product, price_cents: 0
    p3 = create :template_product, price_cents: 1

    t1 = p1.productable
    t2 = p2.productable
    t3 = p3.productable
    t4 = create :template
    t5 = create :template, premium_template: true

    v1 = create :video, account: subject

    m1 = create :message, account: subject, video: v1, template: t1
    m2 = create :message, account: subject, video: v1, template: t2
    m22 = create :message, account: subject, video: v1, template: t2

    expect(subject.used_templates.distinct).to contain_exactly(t1, t2)
    expect(subject.used_templates.free_templates.distinct).to contain_exactly(t1, t2)

    # plan
    expect(subject.can_use_template?(t1)).to eq true
    expect(subject.can_use_template?(t3)).to eq false

    subject.current_plan.free_template_limit = 3
    expect(subject.can_use_template?(t4)).to eq true

    subject.current_plan.premium_templates = false
    expect(subject.can_use_template?(t5)).to eq false

    subject.current_plan.premium_templates = true
    expect(subject.can_use_template?(t5)).to eq true

    subject.current_plan.free_template_limit = 2
    expect(subject.can_use_template?(t4)).to eq false
  end

  it '#available_templates' do
    p1 = create :template_product, price_cents: 0
    p2 = create :template_product, price_cents: 1
    p3 = create :template_product, price_cents: 2

    t1 = p1.productable
    t2 = p2.productable
    t3 = p3.productable

    expect(subject.available_templates).to contain_exactly(t1)

    subject.templates << t2
    expect(subject.available_templates).to contain_exactly(t1, t2)
  end

  it '#my_templates' do
    p1 = create :template_product, price_cents: 0
    p2 = create :template_product, price_cents: 1
    p3 = create :template_product, price_cents: 2


    c1 = create :category, default: true
    p1.categories << c1

    t1 = p1.productable
    expect(subject.my_templates).to contain_exactly(t1)

    t2 = p2.productable
    t3 = p3.productable

    subject.templates << t2
    expect(subject.my_templates).to contain_exactly(t1, t2)
  end

  it '.has_product?' do
    p1 = create :template_product, price_cents: 0
    p2 = create :template_product, price_cents: 0
    t1 = p1.productable
    subject.templates << t1
    expect(subject.has_product?(p1)).to eq true
    expect(subject.has_product?(p2)).to eq false
  end

  describe '.can_use_product?' do
    it 'free account' do
      p1 = create :template_product, price_cents: 0
      p2 = create :template_product, price_cents: 0
      p3 = create :template_product, price_cents: 0
      p4 = create :template_product, price_cents: 0

      t1 = p1.productable
      t2 = p2.productable
      t3 = p3.productable

      subject.templates << t1

      expect(subject.can_use_product?(p1)).to eq false
      expect(subject.can_use_product?(p2)).to eq true
      expect(subject.can_use_product?(p3)).to eq true

      subject.templates << t2 << t3
      expect(subject.can_use_product?(p4)).to eq false
    end

    it 'pro account' do
      subject.orders.create! plan_type: 'pro', plan_duration: 12, status: :active, payment_method: 'inatec', expired_at: 1.years.since
      p1 = create :template_product, price_cents: 1
      expect(subject.can_use_product?(p1)).to eq true
    end

    it 'expert account' do
      Order.create_baio_order(subject)
      p1 = create :template_product, price_cents: 1
      expect(subject.can_use_product?(p1)).to eq true
    end
  end

  describe '.can_see_statistics?' do
    it 'free account' do
      expect(subject.can_see_statistics?).to eq false
    end

    it 'pro account' do
      subject.orders.create! plan_type: 'pro', plan_duration: 12, status: :active, payment_method: 'inatec', expired_at: 1.years.since
      expect(subject.can_see_statistics?).to eq true
    end

    it 'expert account' do
      Order.create_baio_order(subject)
      expect(subject.can_see_statistics?).to eq true
    end
  end

end
