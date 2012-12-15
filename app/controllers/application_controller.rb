class ApplicationController < ActionController::Base
  protect_from_forgery
  def destroy
    flash[:error] = "You are successfully logged out!"
    redirect_to("/member")
    session.delete(:user_email)#clear user data from session
  end
  def index
  end 
end
