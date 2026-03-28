# frozen_string_literal: true

class AddBookingFieldsToOrders < ActiveRecord::Migration[7.0]
  def change
    change_table :orders, bulk: true do |t|
      t.string :status, null: false, default: 'pending'
      t.date :starts_on, null: false
      t.integer :event_duration_days, null: false
      t.string :city, null: false
      t.string :country, null: false
      t.text :additional_details, null: false
    end
  end
end
