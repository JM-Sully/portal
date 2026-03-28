# frozen_string_literal: true

require 'test_helper'

class OrderEditFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveSupport::Testing::TimeHelpers

  setup do
    @user = users(:one)
    @order = orders(:one)
    @order.update!(user: @user)
  end

  test 'pending order show has edit link leading to form and successful update shows updated time' do
    sign_in @user
    t = Time.zone.parse('2026-03-20 10:00:00')
    @order.update_columns(created_at: t, updated_at: t)
    @order.reload

    get order_path(@order)
    assert_response :success
    assert_select 'dt', text: 'Updated', count: 0

    assert_select "a[href='#{edit_order_path(@order)}']", text: 'Edit'
    get edit_order_path(@order)
    assert_response :success

    travel_to Time.zone.local(2026, 7, 1, 12, 0, 0) do
      patch order_path(@order), params: {
        order: {
          starts_on: Date.new(2026, 7, 20).to_s,
          event_duration_days: 2,
          city: 'Halifax',
          country: 'Canada',
          additional_details: 'Revised details after discussion.'
        }
      }
    end
    assert_redirected_to order_path(@order)
    follow_redirect!
    assert_response :success
    assert_select 'dt', text: 'Updated'
    assert_match(/\d{1,2} July 2026 at \d{1,2}:\d{2}/, response.body)
    assert_match(/Halifax/, response.body)
    assert_match(/Revised details after discussion/, response.body)
  end
end
