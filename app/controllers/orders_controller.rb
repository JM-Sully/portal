# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: :show

  rescue_from ActiveRecord::RecordNotFound, with: :order_not_found

  def show; end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_not_found
    redirect_to root_path, alert: 'Order not found.'
  end
end
