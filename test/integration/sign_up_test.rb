# frozen_string_literal: true

require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest
  test 'displays first name and last name fields on sign up page' do
    get new_user_registration_path
    assert_response :success
    assert_select 'input[name="user[first_name]"]'
    assert_select 'input[name="user[last_name]"]'
  end

  test 'successfully signs up with all required fields' do
    assert_difference('User.count', 1) do
      post user_registration_path, params: { user: valid_sign_up_params }
    end

    user = User.find_by(email: 'newuser@example.com')
    assert_equal 'Jane', user.first_name
    assert_equal 'Doe', user.last_name
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.notice', text: /Welcome, Jane!/
  end

  test 'fails to sign up without first name' do
    assert_no_difference('User.count') do
      post user_registration_path, params: { user: valid_sign_up_params(first_name: '') }
    end

    assert_response :unprocessable_entity
    assert_select '#error_explanation', /First name/
  end

  test 'fails to sign up without last name' do
    assert_no_difference('User.count') do
      post user_registration_path, params: { user: valid_sign_up_params(last_name: '') }
    end

    assert_response :unprocessable_entity
    assert_select '#error_explanation', /Last name/
  end

  test 'fails to sign up without email' do
    assert_no_difference('User.count') do
      post user_registration_path, params: { user: valid_sign_up_params(email: '') }
    end

    assert_response :unprocessable_entity
  end

  private

  def valid_sign_up_params(**overrides)
    {
      first_name: 'Jane',
      last_name: 'Doe',
      email: 'newuser@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    }.merge(overrides)
  end
end
