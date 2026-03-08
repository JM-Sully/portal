# frozen_string_literal: true

require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @product1 = products(:one)
    @product2 = products(:two)
  end

  test 'redirects to sign in when not authenticated' do
    get root_path
    assert_redirected_to new_user_session_path
  end

  test 'displays home page when authenticated' do
    sign_in @user
    get root_path
    assert_response :success
    assert_select 'h2', text: 'My Orders'
    assert_select 'h2', text: 'Available Services'
  end

  test 'displays empty orders message when user has no orders' do
    sign_in @user
    # Ensure user has no orders
    Order.where(user: @user).destroy_all
    get root_path
    assert_response :success
    assert_select 'p', text: /You haven't placed any orders yet/
  end

  test 'displays user orders when they exist' do
    sign_in @user
    order = orders(:one)
    order.update(user: @user)

    get root_path
    assert_response :success
    assert_select 'h3', text: @product1.title
  end

  test 'displays all available products' do
    sign_in @user
    get root_path
    assert_response :success
    assert_select 'h3', text: @product1.title
    assert_select 'h3', text: @product2.title
  end

  test 'displays purchase buttons for products without external URLs' do
    sign_in @user
    get root_path
    assert_response :success
    assert_select 'button', text: 'Purchase'
  end

  test 'displays external link for products with external URLs' do
    @product1.update(external_url: 'https://www.rover.com')
    sign_in @user
    get root_path
    assert_response :success
    assert_select 'a', text: 'Book on Rover'
  end

  test 'displays variable pricing text when applicable' do
    sign_in @user
    get root_path
    assert_response :success
    assert_select 'span', text: 'Variable pricing'
  end

  test 'displays footer when authenticated' do
    sign_in @user
    get root_path
    assert_response :success
    assert_select 'footer' do
      assert_select 'p', text: 'Sullips Ltd'
      assert_select 'p', text: 'Established January 2026'
    end
  end

  test 'displays contact jess button in footer' do
    sign_in @user
    get root_path
    assert_response :success
    assert_select 'footer button', text: 'Contact Jess'
  end

  test 'does not display footer when not authenticated' do
    get new_user_session_path
    assert_response :success
    assert_select 'footer', count: 0
  end
end
