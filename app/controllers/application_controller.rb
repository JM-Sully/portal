# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :layout_by_resource

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  protected

  # Avoid sending users to an order URL they cannot access after sign-in/sign-up (e.g. stale
  # stored location from a shared link or another session). That flow used to hit OrdersController
  # and flash "Order not found." on the home page.
  def resolve_post_auth_redirect(path, user)
    return path unless path.is_a?(String)

    path_only = path.sub(%r{\Ahttps?://[^/]+}, '')
    match = path_only.match(%r{\A/orders/(\d+)(?:/edit)?\z})
    return path unless match

    order_id = match[1].to_i
    return path if user.orders.exists?(id: order_id)

    # Path only (not url_helpers.root_path): safe when Devise calls this without a full request.
    '/'
  end

  private

  def layout_by_resource
    devise_controller? ? 'devise_auth' : 'application'
  end
end
