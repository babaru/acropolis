class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me, :avatar) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :name, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password, :avatar) }
  end

  def cache_recent_item(type, id, name)
    logger.debug "type is #{type.class}"
    type = type.to_s if type.is_a?(Symbol)
    session['recent'] ||= {}
    session['recent'][type] ||= {}
    session['recent'][type][id.to_s] = name
    logger.debug "controller: #{session['recent']}"
  end
end
