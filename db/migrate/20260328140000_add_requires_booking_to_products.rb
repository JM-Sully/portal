# frozen_string_literal: true

class AddRequiresBookingToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :requires_booking, :boolean, null: false, default: true
  end
end
