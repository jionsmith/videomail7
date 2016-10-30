# This file is used by Rack-based servers to start the application.

require 'sidekiq/web'
require ::File.expand_path('../config/environment',  __FILE__)
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'defaultpw'
end
run Rails.application
