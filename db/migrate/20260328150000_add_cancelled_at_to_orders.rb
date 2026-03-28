# frozen_string_literal: true

class AddCancelledAtToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :cancelled_at, :datetime
  end
end
