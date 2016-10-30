require 'rails_helper'

RSpec.describe Package, type: :model do
  subject do
    create :package
  end

  it 'subject' do
    pp subject
    expect(subject).to be_a described_class
  end

  it '#product_name' do
    create(:package, name: 'Worldcup 2014').product_name.should eq 'Worldcup 2014'
  end
end
