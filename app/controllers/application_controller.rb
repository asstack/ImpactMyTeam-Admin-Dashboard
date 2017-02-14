class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.has_role? :admin
      flash[:alert] = "This area is restricted!"
      redirect_to root_path
    end
  end

  def admin_user_signed_in?
    user_signed_in? && current_user.has_role?(:admin)
  end

  def current_admin_user
    return nil unless admin_user_signed_in?
    current_user
  end

  helper_method :admin_user_signed_in?, :current_admin_user

  # Allow for proper redirects after using the navigation header login form
  def after_sign_in_path_for(resource)
    if request.referer =~ /\/users/
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def schools_query
    @schools_query ||= params[:query]
  end
  helper_method :schools_query
end
