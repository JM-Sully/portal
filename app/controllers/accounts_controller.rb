# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(account_params)
      redirect_to root_path, notice: 'Your account has been updated successfully.'
    else
      flash.now[:alert] = 'Please correct the errors below.'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
