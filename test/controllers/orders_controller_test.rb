# frozen_string_literal: true

require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveSupport::Testing::TimeHelpers

  setup do
    @user = users(:one)
    @order = orders(:one)
    @order.update!(user: @user)
  end

  test 'show displays booking details for owner' do
    sign_in @user
    get order_path(@order)
    assert_response :success
    assert_select 'h1', text: @order.product.title
    assert_match @order.city, response.body
    assert_match @order.country, response.body
    assert_match @order.additional_details, response.body
  end

  test 'show redirects when order belongs to another user' do
    sign_in @user
    other_order = orders(:two)
    get order_path(other_order)
    assert_redirected_to root_path
    assert_equal 'Order not found.', flash[:alert]
  end

  test 'show redirects when id does not exist' do
    sign_in @user
    get order_path(999_999)
    assert_redirected_to root_path
    assert_equal 'Order not found.', flash[:alert]
  end

  test 'show requires authentication' do
    get order_path(@order)
    assert_redirected_to new_user_session_path
  end

  test 'show includes edit link only for pending orders' do
    sign_in @user
    get order_path(@order)
    assert_select "a[href='#{edit_order_path(@order)}']", text: 'Edit'

    @order.update!(status: :confirmed)
    get order_path(@order)
    assert_select "a[href='#{edit_order_path(@order)}']", count: 0
  end

  test 'edit renders for pending order owner' do
    sign_in @user
    get edit_order_path(@order)
    assert_response :success
    assert_select 'h2', text: 'Edit booking'
    assert_select 'form[action=?]', order_path(@order)
  end

  test 'edit redirects when order is not pending' do
    sign_in @user
    @order.update!(status: :confirmed)
    get edit_order_path(@order)
    assert_redirected_to order_path(@order)
    assert_match(/Only pending bookings can be edited/, flash[:alert])
  end

  test 'edit redirects when order belongs to another user' do
    sign_in @user
    get edit_order_path(orders(:two))
    assert_redirected_to root_path
  end

  test 'update changes booking and redirects' do
    sign_in @user
    travel_to Time.zone.local(2026, 1, 1, 12, 0, 0) do
      patch order_path(@order), params: {
        order: {
          starts_on: Date.new(2026, 1, 20).to_s,
          event_duration_days: 3,
          city: 'Victoria',
          country: 'Canada',
          additional_details: 'Updated notes for Jess.'
        }
      }
    end
    assert_redirected_to order_path(@order)
    assert_equal 'Changes saved.', flash[:notice]
    @order.reload
    assert_equal 'Victoria', @order.city
    assert_equal 3, @order.event_duration_days
    assert_equal 'Updated notes for Jess.', @order.additional_details
  end

  test 'update renders edit with errors when date is too soon' do
    sign_in @user
    travel_to Time.zone.local(2026, 1, 1, 12, 0, 0) do
      patch order_path(@order), params: {
        order: {
          starts_on: Date.new(2026, 1, 10).to_s,
          event_duration_days: @order.event_duration_days,
          city: @order.city,
          country: @order.country,
          additional_details: @order.additional_details
        }
      }
    end
    assert_response :unprocessable_entity
    assert_select '#error_explanation'
  end

  test 'update redirects when order is not pending' do
    sign_in @user
    @order.update!(status: :confirmed)
    patch order_path(@order), params: {
      order: {
        starts_on: @order.starts_on,
        event_duration_days: @order.event_duration_days,
        city: @order.city,
        country: @order.country,
        additional_details: @order.additional_details
      }
    }
    assert_redirected_to order_path(@order)
    assert_match(/Only pending bookings can be edited/, flash[:alert])
  end
end
