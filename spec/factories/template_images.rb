FactoryGirl.define do
  factory :template_image do
    template
    image_file { File.open Rails.root.join('spec/fixtures/healthy2', 'top.png') }
  end
end
