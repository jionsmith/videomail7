class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: :omniauth

  # GET /p/:referrer_code
  def promolink
    unless current_account
      session[:referrer_code] = params[:referrer_code]
    end

    redirect_to root_path
  end

  def create
    devise_parameter_sanitizer.for(:sign_up) << :referrer_code
    params[:account][:referrer_code] = session[:referrer_code] if session[:referrer_code].present?
    super

    if resource.persisted? && session[:referrer_code].present?
      session[:referrer_code] = nil
    end
  end

  def edit
    render layout: 'application'
  end

  def update
    if current_account.update(update_params)
      flash.now[:success] = 'Profile updated'
    else
      flash.now[:alert] = 'Profile update failed'
    end

    render 'edit', layout: 'application'
  end

  def cancel_account
  end

  def omniauth
    auth = request.env['omniauth.auth']
    auth[:referrer_code] = session[:referrer_code] if session[:referrer_code].present?
    @account = Account.from_omniauth(auth)

    if @account.persisted? && session[:referrer_code].present?
      session[:referrer_code] = nil
    end

    flash[:success] = 'Signed in.'

    sign_in @account
    redirect_to root_path
  end

  private

  def update_params
    params.require(:account).permit(:first_name, :last_name)
  end
end
