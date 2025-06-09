class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :configure_permitted_parameters, if: :devise_controller?
  allow_browser versions: :modern
  before_action :authenticate_user!
  layout :layout_by_resource

  protected

  def configure_permitted_parameters
    # Permit the `subscribe_newsletter` parameter along with the other
    # sign up parameters.
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
  end

  private

  def layout_by_resource
    return "turbo_rails/frame" if turbo_frame_request?
    devise_controller? ? "devise" : "application"
  end
end
