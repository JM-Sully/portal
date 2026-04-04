# frozen_string_literal: true

require 'test_helper'

class BookingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @bookable = products(:one)
    @external_only = products(:three)
  end

  test 'new when authenticated' do
    sign_in @user
    get new_product_booking_path(@bookable)
    assert_response :success
    assert_select 'h2', text: 'Request a booking'
    assert_select 'input[type="submit"][value="Request booking with Jess"]'
  end

  test 'redirects to sign in when not authenticated' do
    get new_product_booking_path(@bookable)
    assert_redirected_to new_user_session_path
  end

  test 'rejects non-bookable product' do
    sign_in @user
    get new_product_booking_path(@external_only)
    assert_redirected_to root_path
    assert_equal 'This service does not use the booking form.', flash[:alert]
  end

  test 'rejects unknown product' do
    sign_in @user
    get new_product_booking_path(product_id: 999_999)
    assert_redirected_to root_path
    assert_equal 'Product not found.', flash[:alert]
  end

  test 'create persists pending order' do
    sign_in @user
    Order.where(user: @user, product: @bookable).destroy_all

    assert_difference 'Order.count', 1 do
      post product_booking_path(@bookable), params: {
        order: {
          starts_on: (Date.current + 30.days).to_s,
          event_duration_days: 3,
          city: 'Inverness',
          country: 'Scotland',
          additional_details: 'Need accessibility notes.'
        }
      }
    end
    assert_redirected_to root_path
    assert_match(/Pending/, flash[:notice])

    order = Order.order(:created_at).last
    assert_equal 'pending', order.status
    assert_equal 'Inverness', order.city
    assert_equal 3, order.event_duration_days
  end

  test 'create renders new on validation errors' do
    sign_in @user
    assert_no_difference 'Order.count' do
      post product_booking_path(@bookable), params: {
        order: {
          starts_on: '',
          event_duration_days: '',
          city: '',
          country: '',
          additional_details: ''
        }
      }
    end
    assert_response :unprocessable_entity
    assert_select '#error_explanation'
  end
end
