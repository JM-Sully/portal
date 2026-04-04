# frozen_string_literal: true

class Product < ApplicationRecord
  AMOUNT_TYPE_VARIABLE = 'variable'.freeze

  DISPLAY_ORDER = [
    'Conference Talk',
    'A guided Lowland Walk',
    'Dog Sitting'
  ].freeze

  has_many :orders, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :amount_type, inclusion: { in: [AMOUNT_TYPE_VARIABLE] }, allow_nil: true
  validate :booking_channel_consistent

  scope :ordered, -> { in_order_of(:title, DISPLAY_ORDER) }

  def variable_pricing?
    amount_type == AMOUNT_TYPE_VARIABLE
  end

  private

  def booking_channel_consistent
    has_external = external_url.present?
    in_app = requires_booking == true

    if has_external && in_app
      errors.add(:base, 'cannot use both an external URL and in-app booking')
    elsif !has_external && !in_app
      errors.add(:base, 'must provide an external booking URL or enable in-app booking')
    end
  end
end
