# frozen_string_literal: true

require 'test_helper'

class OrderShowFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @order = orders(:one)
    @order.update!(user: @user)
  end

  test 'user opens pending order from home and sees full booking details' do
    sign_in @user
    get root_path
    assert_response :success

    assert_select "a[href='#{order_path(@order)}']"
    get order_path(@order)
    assert_response :success
    assert_select 'dt', text: 'Start date'
    assert_select 'dt', text: 'Number of days'
    assert_select 'dt', text: 'City'
    assert_select 'dt', text: 'Country'
    assert_select 'dt', text: 'Additional details'
    assert_select 'dd', text: @order.additional_details
  end
end
