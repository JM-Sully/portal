# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show edit update cancel]
  before_action :ensure_pending_order, only: %i[edit update]
  before_action :ensure_can_cancel, only: :cancel

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

  def cancel
    if @order.update(status: :cancelled, cancelled_at: Time.current)
      redirect_to order_path(@order), notice: 'Booking cancelled.'
    else
      redirect_to order_path(@order), alert: @order.errors.full_messages.to_sentence
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

  def ensure_can_cancel
    return if @order.pending? || @order.confirmed?

    redirect_to order_path(@order), alert: 'This booking cannot be cancelled.'
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
    redirect_to root_path,
                alert: "That booking isn't available. It may have been removed, or it may belong to a different account."
  end
end
