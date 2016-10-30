Rails.application.config.middleware.use OmniAuth::Builder do
  provider :bonofa, Rails.application.secrets[:bonofa]["app_id"], Rails.application.secrets[:bonofa]["secret_key"]
end
