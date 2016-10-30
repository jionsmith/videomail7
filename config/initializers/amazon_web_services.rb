s3_settings = Rails.application.secrets[:s3]
AWS.config(access_key_id: s3_settings["access_key_id"], 
           secret_access_key: s3_settings["secret_access_key"], 
           region: s3_settings["region"])