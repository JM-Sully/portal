# frozen_string_literal: true

require 'test_helper'

class AccountTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test 'displays account icon in header' do
    get root_path
    assert_response :success
    assert_select 'a[href=?]', edit_account_path
  end

  test 'redirects to sign in when not authenticated' do
    sign_out @user
    get edit_account_path
    assert_redirected_to new_user_session_path
  end

  test 'displays edit account page with user details' do
    get edit_account_path
    assert_response :success
    assert_select 'h2', text: 'Account Settings'
    assert_select 'input[name="user[first_name]"]' do |elements|
      assert_equal @user.first_name, elements.first['value']
    end
    assert_select 'input[name="user[last_name]"]' do |elements|
      assert_equal @user.last_name, elements.first['value']
    end
    assert_select 'p', text: @user.email
  end

  test 'does not render an editable email field' do
    get edit_account_path
    assert_response :success
    assert_select 'input[name="user[email]"]', count: 0
  end

  test 'successfully updates first and last name' do
    patch account_path, params: { user: { first_name: 'Updated', last_name: 'Name' } }
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.notice', text: /Your account has been updated successfully/

    @user.reload
    assert_equal 'Updated', @user.first_name
    assert_equal 'Name', @user.last_name
  end

  test 'fails to update with blank first name' do
    patch account_path, params: { user: { first_name: '', last_name: 'Name' } }
    assert_response :unprocessable_entity
    assert_select 'div.alert', text: /Please correct the errors below/
    assert_select '#error_explanation', /First name/
  end

  test 'fails to update with blank last name' do
    patch account_path, params: { user: { first_name: 'Updated', last_name: '' } }
    assert_response :unprocessable_entity
    assert_select 'div.alert', text: /Please correct the errors below/
    assert_select '#error_explanation', /Last name/
  end

  test 'does not allow email to be changed via account update' do
    original_email = @user.email
    patch account_path, params: { user: { first_name: 'Updated', last_name: 'Name', email: 'hacker@example.com' } }
    assert_redirected_to root_path

    @user.reload
    assert_equal original_email, @user.email
  end
end
