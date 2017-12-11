class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

private

	def confirm_logged_in
    # unless session[:user_id]
    #   flash[:notice] = "Please log in."
    #   redirect_to(access_login_path)
    #   # redirect_to prevents requested action from running
    # end
  end
  
  def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
  	{ locale: I18n.locale }.merge options
	end

end
