# http://localhost:3000/rails/mailers
class AppPreview < ActionMailer::Preview
  def payment_success_mail
    AccountMailer.payment_success_mail(Order.first.id)
  end
end
