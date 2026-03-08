# frozen_string_literal: true

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'belongs to user' do
    order = orders(:one)
    assert_not_nil order.user
  end

  test 'belongs to product' do
    order = orders(:one)
    assert_not_nil order.product
  end

  test 'prevents duplicate orders for same user and product' do
    user = users(:one)
    product = products(:one)
    Order.where(user: user, product: product).destroy_all

    Order.create!(user: user, product: product)
    duplicate_order = Order.new(user: user, product: product)

    assert_not duplicate_order.valid?
    assert_includes duplicate_order.errors[:user_id], 'has already ordered this product'
  end

  test 'allows same product for different users' do
    user1 = users(:one)
    user2 = users(:two)
    product = products(:one)
    Order.where(product: product).destroy_all

    Order.create!(user: user1, product: product)
    order2 = Order.new(user: user2, product: product)

    assert order2.valid?
  end

  test 'allows same user to order different products' do
    user = users(:one)
    product1 = products(:one)
    product2 = products(:two)
    Order.where(user: user).destroy_all

    Order.create!(user: user, product: product1)
    order2 = Order.new(user: user, product: product2)

    assert order2.valid?
  end
end
