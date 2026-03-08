# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.includes(:product).order(created_at: :desc)
    @products = Product.ordered
  end
end
