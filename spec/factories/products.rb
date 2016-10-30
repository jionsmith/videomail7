FactoryGirl.define do
  factory :product do
    status 1 # enabled
    price_cents 100
    categories {|c| [c.association(:category)] }

    association :productable, factory: :template, strategy: :build
  end

  factory :template_product, class: 'Product' do
    association :productable, factory: :template, strategy: :build
  end

  factory :package_product, class: 'Product' do
    association :productable, factory: :package, strategy: :build
  end
end
