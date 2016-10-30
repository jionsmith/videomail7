# config/initializers/money.rb
MoneyRails.configure do |config|

  # set the default currency
  config.default_currency = Rails.application.secrets[:currency_code]

end
