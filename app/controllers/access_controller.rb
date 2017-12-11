class AccessController < ApplicationController
  
  before_action :confirm_logged_in, :except => [:login, :attempt_login, :logout]

  def menu
  	user = User.find(session[:user_id])
    if user.is_admin              
      redirect_to(users_path)
    else
    	redirect_to(projections_inputs_path)      
    end
  end

  def login
  
  end

  def attempt_login
  	if params[:username].present? && params[:password].present?
      found_user = User.where(:username => params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
      end
    end

    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "You are now logged in."
      redirect_to(access_menu_path)
    else
      flash.now[:notice] = "Invalid username/password combination."
      render('login')
    end
  end

  def logout
  	session[:user_id] = nil
    flash[:notice] = 'Logged out'
    redirect_to(access_login_path)
  end
end
