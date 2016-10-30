FactoryGirl.define do
  factory :category do
    sequence(:name) {|n| "category#{n}" }
    default false
  end
end
