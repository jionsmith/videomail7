require 'rails_helper'

RSpec.describe Template, type: :model do
  subject do
    create :template
  end

  it 'subject' do
    pp subject
    expect(subject).to be_a described_class
  end

  it '#liquid_template' do
    i1 = create :template_image, template: subject, image_file: File.open(Rails.root.join('spec/fixtures/healthy2', 'top.png'))
    i2 = create :template_image, template: subject, image_file: File.open(Rails.root.join('spec/fixtures/healthy2', 'bottom.png'))
    body = subject.liquid_template.render
    puts body

    expect(body).to include i1.image_file.url
    expect(body).to include i2.image_file.url
  end

  it '.free_templates' do
    p1 = create :template_product, price_cents: 0
    p2 = create :template_product, price_cents: 1

    expect(Template.free_templates).to contain_exactly(p1.productable)
  end

  it '#is_free?' do
    p1 = create :template_product, price_cents: 0
    p2 = create :template_product, price_cents: 1

    t0 = create :template
    t1 = p1.productable
    t2 = p2.productable

    expect(t0.is_free?).to eq true
    expect(t1.is_free?).to eq true
    expect(t2.is_free?).to eq false
  end

  it '.create_from_folder' do
    dir = Rails.root.join('spec/fixtures', 'healthy2')
    a1 = create :account

    t1 = Template.create_from_folder(dir, a1, true)
    t1.reload
    pp t1
    pp t1.template_images
    expect(t1).to be_a Template
    expect(t1).to be_persisted
    expect(t1).to be_premium_template
    expect(t1.author_account).to eq a1
    expect(t1.preview_image).to be_present
    expect(t1.template_images.count).to eq 2

    expect(a1.authored_templates).to contain_exactly(t1)
  end

  it '.import_from_subfolders' do
    dir = Rails.root.join('spec/fixtures')
    a1 = create :account

    stat = Template.import_from_subfolders(dir, a1, true)
    pp stat
    puts stat[:created].inspect
    expect(stat[:created].size).to eq 2
    expect(stat[:skipped].size).to eq 1
  end

end
