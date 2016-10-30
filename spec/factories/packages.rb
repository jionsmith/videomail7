FactoryGirl.define do
  factory :package do
    sequence(:name) {|n| "package#{n}" }
    description "Package's description goes right here."

    before :create do |package|
      unless package.product
        package.product = build :product, price_cents: 0 #, productable: package
      end
    end
  end
end
