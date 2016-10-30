FactoryGirl.define do
  factory :message  do
    account
    video
    template

    sequence(:subject) {|n| "subject#{n}" }
    sequence(:text) {|n| "text#{n}" }
    emails 'aaa@aaa.aa'
  end
end
