# frozen_string_literal: true

require 'test_helper'

class PostAuthRedirectTest < ActiveSupport::TestCase
  fixtures :all

  setup do
    @controller = ApplicationController.new
  end

  test 'resolve_post_auth_redirect sends user to root when order belongs to someone else' do
    order = orders(:one)
    order.update!(user: users(:one))
    bob = users(:two)
    path = "/orders/#{order.id}"

    result = @controller.send(:resolve_post_auth_redirect, path, bob)

    assert_equal '/', result
  end

  test 'resolve_post_auth_redirect keeps path when user owns the order' do
    order = orders(:one)
    order.update!(user: users(:one))
    alice = users(:one)
    path = "/orders/#{order.id}"

    result = @controller.send(:resolve_post_auth_redirect, path, alice)

    assert_equal path, result
  end

  test 'resolve_post_auth_redirect keeps edit path when user owns the order' do
    order = orders(:one)
    order.update!(user: users(:one))
    alice = users(:one)
    path = "/orders/#{order.id}/edit"

    result = @controller.send(:resolve_post_auth_redirect, path, alice)

    assert_equal path, result
  end

  test 'resolve_post_auth_redirect treats absolute URL as order path when user owns order' do
    order = orders(:one)
    order.update!(user: users(:two))
    bob = users(:two)
    path = "http://www.example.com/orders/#{order.id}"

    result = @controller.send(:resolve_post_auth_redirect, path, bob)

    assert_equal path, result
  end

  test 'resolve_post_auth_redirect sends wrong user to root for absolute order URL' do
    order = orders(:one)
    order.update!(user: users(:one))
    bob = users(:two)
    path = "http://www.example.com/orders/#{order.id}"

    result = @controller.send(:resolve_post_auth_redirect, path, bob)

    assert_equal '/', result
  end

  test 'resolve_post_auth_redirect leaves non-order paths unchanged' do
    bob = users(:two)
    path = '/some/other/path'

    result = @controller.send(:resolve_post_auth_redirect, path, bob)

    assert_equal path, result
  end
end
