# frozen_string_literal: true

require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @product = products(:one)
  end

  test 'should create order when authenticated' do
    sign_in @user
    Order.where(user: @user, product: @product).destroy_all

    assert_difference 'Order.count', 1 do
      post orders_path, params: { product_id: @product.id }
    end
    assert_redirected_to root_path
    assert_equal 'Order placed successfully!', flash[:notice]
  end

  test 'should redirect to sign in when not authenticated' do
    post orders_path, params: { product_id: @product.id }
    assert_redirected_to new_user_session_path
  end

  test 'should handle invalid product_id' do
    sign_in @user
    post orders_path, params: { product_id: 99999 }
    assert_redirected_to root_path
    assert_equal 'Product not found.', flash[:alert]
  end

  test 'should prevent duplicate orders' do
    sign_in @user
    Order.where(user: @user, product: @product).destroy_all
    Order.create!(user: @user, product: @product)

    assert_no_difference 'Order.count' do
      post orders_path, params: { product_id: @product.id }
    end
    assert_redirected_to root_path
    assert_match(/already ordered/, flash[:alert])
  end

  test 'should not change order count for unauthenticated request' do
    assert_no_difference 'Order.count' do
      post orders_path, params: { product_id: @product.id }
    end
  end
end
