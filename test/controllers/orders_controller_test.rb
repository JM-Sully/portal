# frozen_string_literal: true

require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

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
end
