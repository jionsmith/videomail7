class Admin::SettingsController < Admin::BaseController
  def index
  end

  def update
    setting = Setting.find(params[:id])
    setting.update_attributes(setting_params)
    flash[:success] = "Setting updated successfully."
    redirect_to admin_settings_path
  end

  private

  def setting_params
    params.require(:setting).permit(:key, :value)
  end
end
