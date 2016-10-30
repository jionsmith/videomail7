class PagesController < ApplicationController
  skip_before_action :authenticate_account!
  skip_before_action :verify_authenticity_token

  def imprint
  end

  def contact
  end
end
