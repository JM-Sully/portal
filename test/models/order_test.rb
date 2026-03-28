# frozen_string_literal: true

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'associations' do
    order = orders(:one)
    assert_not_nil order.user
    assert_not_nil order.product
  end

  test 'requires booking fields' do
    user = users(:one)
    product = products(:one)
    order = Order.new(user: user, product: product, status: 'pending')
    assert_not order.valid?
    assert_includes order.errors[:starts_on], "can't be blank"
    assert_includes order.errors[:additional_details], "can't be blank"
  end

  test 'rejects blank additional_details' do
    user = users(:one)
    product = products(:one)
    order = Order.new(
      user: user,
      product: product,
      status: 'pending',
      starts_on: Date.current + 21.days,
      event_duration_days: 1,
      city: 'Edinburgh',
      country: 'Scotland',
      additional_details: '   '
    )
    assert_not order.valid?
    assert_includes order.errors[:additional_details], "can't be blank"
  end

  test 'allows same user to place multiple orders for the same product' do
    user = users(:one)
    product = products(:one)
    Order.where(user: user, product: product).destroy_all

    Order.create!(
      user: user,
      product: product,
      status: 'pending',
      starts_on: Date.current + 30.days,
      event_duration_days: 1,
      city: 'A',
      country: 'B',
      additional_details: 'First booking.'
    )
    second = Order.new(
      user: user,
      product: product,
      status: 'pending',
      starts_on: Date.current + 40.days,
      event_duration_days: 2,
      city: 'C',
      country: 'D',
      additional_details: 'Second booking.'
    )
    assert second.valid?
  end

  test 'allows same user to order different products' do
    user = users(:one)
    product1 = products(:one)
    product2 = products(:two)
    Order.where(user: user).destroy_all

    Order.create!(
      user: user,
      product: product1,
      status: 'pending',
      starts_on: Date.current + 14.days,
      event_duration_days: 1,
      city: 'X',
      country: 'Y',
      additional_details: 'Walk details.'
    )
    order2 = Order.new(
      user: user,
      product: product2,
      status: 'pending',
      starts_on: Date.current + 21.days,
      event_duration_days: 1,
      city: 'X',
      country: 'Y',
      additional_details: 'Talk details.'
    )
    assert order2.valid?
  end

  test 'rejects start date before two week lead time' do
    user = users(:one)
    product = products(:one)
    order = Order.new(
      user: user,
      product: product,
      status: 'pending',
      starts_on: Date.current + 13.days,
      event_duration_days: 1,
      city: 'Edinburgh',
      country: 'Scotland',
      additional_details: 'Notes.'
    )
    assert_not order.valid?
    assert_includes order.errors[:starts_on], 'must be at least two weeks from today so Jess has time to prepare'
  end

  test 'rejects start date in the past' do
    user = users(:one)
    product = products(:one)
    order = Order.new(
      user: user,
      product: product,
      status: 'pending',
      starts_on: Date.current - 1.day,
      event_duration_days: 1,
      city: 'Edinburgh',
      country: 'Scotland',
      additional_details: 'Notes.'
    )
    assert_not order.valid?
    assert_includes order.errors[:starts_on], 'must be at least two weeks from today so Jess has time to prepare'
  end

  test 'allows start date exactly two weeks from today' do
    user = users(:one)
    product = products(:one)
    order = Order.new(
      user: user,
      product: product,
      status: :pending,
      starts_on: Order.earliest_bookable_starts_on,
      event_duration_days: 1,
      city: 'Edinburgh',
      country: 'Scotland',
      additional_details: 'Notes.'
    )
    assert order.valid?
  end

  test 'rejects invalid event duration' do
    user = users(:one)
    product = products(:one)
    order = Order.new(
      user: user,
      product: product,
      status: 'pending',
      starts_on: Date.current + 21.days,
      event_duration_days: 0,
      city: 'Edinburgh',
      country: 'Scotland',
      additional_details: 'Notes.'
    )
    assert_not order.valid?
  end
end
