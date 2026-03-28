# frozen_string_literal: true

class Order < ApplicationRecord
  enum status: {
    pending: 'pending',
    confirmed: 'confirmed',
    cancelled: 'cancelled'
  }

  belongs_to :user
  belongs_to :product

  validates :starts_on, presence: true
  validates :event_duration_days, presence: true,
                                  numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 365 }
  validates :city, :country, :additional_details, presence: true
  validate :starts_on_minimum_lead_time

  def self.booking_minimum_lead_period
    2.weeks
  end

  def self.earliest_bookable_starts_on
    Date.current + booking_minimum_lead_period
  end

  private

  def starts_on_minimum_lead_time
    return if starts_on.blank?

    earliest = Order.earliest_bookable_starts_on
    return unless starts_on < earliest

    errors.add(:starts_on, 'must be at least two weeks from today so Jess has time to prepare')
  end
end
