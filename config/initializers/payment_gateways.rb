ActiveMerchant::Billing::Base.mode = Rails.env.production? ? :production : :test

::INATEC_GATEWAY = ActiveMerchant::Billing::InatecGateway.new(
  merchant_id:  Rails.application.secrets[:inatec]['merchant_id'],
  secret:       Rails.application.secrets[:inatec]['secret'],
  url_return:   nil,
  custom1:      (Rails.env.production? ? nil : '123456')
)
