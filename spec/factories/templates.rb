FactoryGirl.define do
  factory :template  do
    sequence(:title) {|n| "template#{n}" }
    text_example "Template's description goes right here."
    content_file { File.open Rails.root.join('spec/fixtures/healthy2', 'healthy2.liquid') }
    preview_image { File.open Rails.root.join('spec/fixtures/healthy2', 'preview.jpg') }

    before :create do |template|
      unless template.product
        template.product = build :product, price_cents: 0 #, productable: template
      end
    end
  end
end
