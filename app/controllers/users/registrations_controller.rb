# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    protected

    def after_sign_up_path_for(resource)
      flash[:notice] = "Welcome, #{resource.first_name}! You have signed up successfully."
      super
    end

    private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
    end
  end
end
