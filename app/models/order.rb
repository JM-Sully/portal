# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :user_id, uniqueness: { scope: :product_id, message: 'has already ordered this product' }
end
