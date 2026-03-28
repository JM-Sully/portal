# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show edit update]
  before_action :ensure_pending_order, only: %i[edit update]

  rescue_from ActiveRecord::RecordNotFound, with: :order_not_found

  def show; end

  def edit; end

  def update
    if @order.update(order_params)
      redirect_to order_path(@order), notice: 'Changes saved.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def ensure_pending_order
    return if @order.pending?

    redirect_to order_path(@order), alert: 'Only pending bookings can be edited.'
  end

  def order_params
    params.require(:order).permit(
      :starts_on,
      :event_duration_days,
      :city,
      :country,
      :additional_details
    )
  end

  def order_not_found
    redirect_to root_path, alert: 'Order not found.'
  end
end
