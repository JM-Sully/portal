# frozen_string_literal: true

class Product < ApplicationRecord
  AMOUNT_TYPE_VARIABLE = 'variable'.freeze

  has_many :orders, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :amount_type, inclusion: { in: [AMOUNT_TYPE_VARIABLE] }, allow_nil: true

  scope :ordered, -> { order(created_at: :asc) }

  def variable_pricing?
    amount_type == AMOUNT_TYPE_VARIABLE
  end
end
