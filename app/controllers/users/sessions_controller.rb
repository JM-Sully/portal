# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    protected

    def after_sign_in_path_for(resource)
      flash[:notice] = "Welcome back, #{resource.first_name}!"
      resolve_post_auth_redirect(super, resource)
    end
  end
end
