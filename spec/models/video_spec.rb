require 'rails_helper'

RSpec.describe Video, type: :model do
  subject do
    create :video
  end

  it 'subject' do
    pp subject
    expect(subject).to be_a described_class
  end

  it '.accept_upload?' do
    expect(Video.accept_upload?('1.avi')).to eq true
    expect(Video.accept_upload?('1.bin')).to eq false
  end
end
