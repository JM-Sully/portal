# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:create]

  def create
    @order = current_user.orders.build(product: @product)

    if @order.save
      redirect_to root_path, notice: 'Order placed successfully!'
    else
      redirect_to root_path, alert: @order.errors.full_messages.to_sentence
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Product not found.'
  end
end
