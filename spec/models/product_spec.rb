require 'rails_helper'

RSpec.describe Product, type: :model do
  subject do
    create :product
  end

  it 'subject' do
    pp subject
    expect(subject).to be_a described_class
  end

  it 'template_product' do
    p1 = create :template_product, price_cents: 10
    expect(Product.count).to eq 1
    expect(Template.count).to eq 1

    t1 = p1.productable
    expect(t1.is_free?).to eq false
  end

  it '#price_cents' do
    build(:product, price_cents: -1000).should_not be_valid
  end

  it '#formatted_status' do
    create(:product, status: 0).formatted_status.should eq :disabled
    create(:product, status: 1).formatted_status.should eq :enabled
  end

  it '#name' do
    package = create(:package, name: 'Package1')
    create(:package_product, productable: package).name.should eq 'Package1'

    template = create(:template, title: 'Template1')
    create(:template_product, productable: template).name.should eq 'Template1'
  end
end
