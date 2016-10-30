class Admin::BaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  before_action :authenticate_account!
  before_filter :authenticate_admin!

  layout 'admin'

  def authenticate_admin!
    unless current_account.has_role? :admin
      redirect_to root_path
    end
  end
end
