if Rails.env.test? || Rails.env.development?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end
