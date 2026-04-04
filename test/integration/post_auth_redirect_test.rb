# frozen_string_literal: true

require 'test_helper'

class PostAuthRedirectIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'sign up does not redirect to another users order or show order not found flash' do
    order = orders(:one)

    get order_path(order)
    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_difference -> { User.count }, 1 do
      post user_registration_path, params: {
        user: {
          first_name: 'New',
          last_name: 'User',
          email: 'fresh-signup@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_not_includes response.body, "That booking isn't available"
  end
end
