class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Sorry, but the access is denied for you."
    redirect_to root_url
  end
end
