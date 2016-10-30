unless Rails.env.test?
  s3_settings = Rails.application.secrets[:s3]
  if Rails.env.test? or Rails.env.cucumber?
    CarrierWave.configure do |config|
      config.storage = :file
      config.enable_processing = false
    end
  elsif s3_settings && s3_settings["access_key_id"].present?
    CarrierWave.configure do |config|
      config.storage = :fog
      config.fog_credentials = {
        :provider               => 'AWS',                        # required
        :aws_access_key_id      => s3_settings["access_key_id"],                        # required
        :aws_secret_access_key  => s3_settings["secret_access_key"],                        # required
        :region                 => s3_settings["region"]
      }
      config.fog_directory  = s3_settings["bucket"]                     # required
    end
  else
    CarrierWave.configure do |config|
      config.storage = :file
    end
  end
end
