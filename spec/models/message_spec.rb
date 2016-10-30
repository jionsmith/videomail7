require 'rails_helper'

RSpec.describe Message, type: :model do
  subject do
    create :message
  end

  it 'subject' do
    pp subject
    expect(subject).to be_a described_class
  end

  it '#token' do
    expect(subject.token.length).to be >= 16
  end

  it '.delayed_email?' do
    subject.email_type = 1
    expect(subject.delayed_email?).to eq true
  end

  it '.read_by!' do
    expect(subject.read_by?('a1@email.com')).to eq false
    subject.read_by!('a1@email.com')
    expect(subject.read_by?('a1@email.com')).to eq true
  end

  it '.read_by?' do
    expect(subject.read_by?('a1@email.com')).to eq false
    subject.read_by!('a1@email.com')
    expect(subject.read_by?('a1@email.com')).to eq true
  end

  it '.read_any?' do
    expect(subject.read_any?).to eq false
    subject.read_by!('a1@email.com')
    expect(subject.read_any?).to eq true
  end

  it '.deliver' do
    ActionMailer::Base.deliveries.clear
    subject.deliver
    expect(ActionMailer::Base.deliveries.count).to eq 1
  end

  it '.deliver_now' do
    ActionMailer::Base.deliveries.clear
    subject.emails = "a1@email.com, a2@email.com"
    subject.deliver_now
    expect(ActionMailer::Base.deliveries.count).to eq 2
  end

  it '.deliver_later' do
    ActionMailer::Base.deliveries.clear
    subject.deliver_later
    expect(ActionMailer::Base.deliveries.count).to eq 0
    expect(subject.delayed?).to eq true
  end

  it '#deliver_delayed' do
    m1 = create :message, send_at: 1.hours.ago, status: 'delayed', email_type: 1
    p1 = create :template_product, price_cents: 0
    t1 = p1.productable
    m1.template = t1
    m1.save
    Message.deliver_delayed
    expect(ActionMailer::Base.deliveries.count).to eq 1
    expect(m1.reload.sent?).to eq true
  end

  describe 'validation' do
    it 'should not be vaild without emails' do
      expect(build :message, emails: nil).to be_invalid
      expect(build :message, emails: '').to be_invalid
    end

    describe 'validates template' do
      before(:each) do
        @p1 = create :template_product, price_cents: 0
        @p2 = create :template_product, price_cents: 10
        @t1 = @p1.productable
        @t2 = @p2.productable
      end

      describe 'free account' do
        it 'should not be valid with non-free template' do
          expect(build :message, template: @t2 ).to be_invalid
        end
      end

      describe 'pro account' do
        it 'should not be valid with unpurchased non-free template' do
          expect(build :message, template: @t2 ).to be_invalid
        end
      end

      describe 'expert account' do
        it 'should not be valid with unpurchased non-free template' do
          expect(build :message, template: @t2 ).to be_invalid
        end
      end
    end

    describe 'validates play' do
      it 'should not be vaild without video and playlist' do
        subject.video = nil
        subject.playlist = nil
        expect(subject).to be_invalid
      end

      it 'should not be vaild without playlist when play=list' do
        subject.play = 'list'
        subject.playlist = nil
        expect(subject).to be_invalid
      end

      it 'should not be vaild without video when play is not list' do
        subject.play = nil
        subject.video = nil
        expect(subject).to be_invalid
      end
    end

    describe 'validates send_at' do
      it 'should not be valid without future send_at for the delayed email' do
        subject.email_type = 1
        subject.status = 'draft'
        subject.send_at = 1.days.ago
        expect(subject).to be_invalid
      end
    end

    describe 'validates video' do
      it 'should not be vaild if video duration exceed' do
        video = create :video, duration: subject.account.current_plan.video_duration_limit+1
        subject.video = video
        expect(subject).to be_invalid
      end
    end

  end

end
