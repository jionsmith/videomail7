class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_account!
  before_filter :restrict_admin_accounts

  around_filter :set_time_zone

  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      if account_signed_in?
        "account_authorized"
      else
        "account_unauthorized"
      end
    end
  end

  def restrict_admin_accounts
    redirect_to admin_root_path if current_account && current_account.has_role?(:admin) && request.method == "GET"
  end
                                                                                 
  def set_time_zone
    old_time_zone = Time.zone
    Time.zone = browser_timezone if browser_timezone.present?
    yield
  ensure
    Time.zone = old_time_zone
  end
                                                                                   
  def browser_timezone
    cookies["browser.timezone"]
  end

end
