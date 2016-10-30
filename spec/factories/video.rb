FactoryGirl.define do
  factory :video  do
    account
    sequence(:title) {|n| "title#{n}" }
    encoded true
    stream_name nil

    panda_video_id 'c603419268d6e1fadea164933d3f27ed'
    screenshot 'http://videomail7-staging.s3.amazonaws.com/f079781f47e72c43f7922fcf29adf311_1.jpg'
    h264_url 'http://videomail7-staging.s3.amazonaws.com/5bb63ad4a0f6a7e9cbe902c994d2c1a8.mp4'
    ogg_url 'http://videomail7-staging.s3.amazonaws.com/f079781f47e72c43f7922fcf29adf311.ogv'
    height '480'
    width '640'
    file_size '5510872'
    duration 1000
  end
end
