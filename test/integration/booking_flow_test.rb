# frozen_string_literal: true

require 'test_helper'

class BookingFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @product = products(:two)
    Order.where(user: @user).destroy_all
  end

  test 'user completes booking and sees pending order on home page' do
    sign_in @user
    get root_path
    assert_response :success
    assert_select 'a', text: 'Request booking'

    get new_product_booking_path(@product)
    assert_response :success

    start_date = Date.current + 21.days
    post product_booking_path(@product), params: {
      order: {
        starts_on: start_date.to_s,
        event_duration_days: 2,
        city: 'Aberdeen',
        country: 'Scotland',
        additional_details: 'Technical audience, 45 minutes slot.'
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success

    assert_select 'span', text: 'Pending'
    assert_select 'h3', text: @product.title
    assert_match(/Aberdeen/, response.body)
    assert_match(/Scotland/, response.body)
  end
end
