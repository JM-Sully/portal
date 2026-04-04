# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_bookable_product

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params.merge(product: @product, status: :pending))

    if @order.save
      redirect_to root_path, notice: 'Your booking request was sent. It appears as Pending until Jess confirms.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def load_bookable_product
    @product = Product.find_by(id: params[:product_id])
    if @product&.requires_booking?
      return
    end

    message = @product ? 'This service does not use the booking form.' : 'Product not found.'
    redirect_to root_path, alert: message
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
end
