# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    protected

    def after_sign_in_path_for(resource)
      flash[:notice] = "Welcome back, #{resource.first_name}!"
      super
    end
  end
end
