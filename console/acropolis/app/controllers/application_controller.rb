class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  before_action :configure_permitted_parameters, if: :devise_controller?

  def recent_items(type)
    type = type.to_s if type.is_a?(Symbol)
    session['recent'] ||= {}
    session['recent'][type] ||= {}
    session['recent'][type]
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me, :avatar) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :name, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password, :avatar) }
  end

  def cache_recent_item(type, id, name)
    type = type.to_s if type.is_a?(Symbol)
    session['recent'] ||= {}
    session['recent'][type] ||= {}
    session['recent'][type][id.to_s] = name
  end

  def remove_recent_item(type, id)
    type = type.to_s if type.is_a?(Symbol)
    session['recent'] ||= {}
    session['recent'][type] ||= {}
    session['recent'][type].delete(id.to_s)
  end

  def json_request?
    request.format.json?
  end
end
