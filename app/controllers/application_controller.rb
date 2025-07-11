class ApplicationController < ActionController::Base
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout_by_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
  end

  private

  def ensure_turbo_stream_request!
    return if request.format.turbo_stream?

    head :not_acceptable
  end

  def layout_by_resource
    return "turbo_rails/frame" if turbo_frame_request?
    devise_controller? ? "devise" : "application"
  end
end
