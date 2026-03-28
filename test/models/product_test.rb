# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'validates presence of title' do
    product = Product.new(description: 'Some description', amount_type: Product::AMOUNT_TYPE_VARIABLE)
    assert_not product.valid?
    assert_includes product.errors[:title], "can't be blank"
  end

  test 'validates presence of description' do
    product = Product.new(title: 'Some title', amount_type: Product::AMOUNT_TYPE_VARIABLE)
    assert_not product.valid?
    assert_includes product.errors[:description], "can't be blank"
  end

  test 'validates amount_type inclusion' do
    product = Product.new(title: 'Title', description: 'Desc', amount_type: 'invalid')
    assert_not product.valid?
    assert_includes product.errors[:amount_type], 'is not included in the list'
  end

  test 'allows nil amount_type' do
    product = Product.new(title: 'Title', description: 'Desc', amount_type: nil)
    assert product.valid?
  end

  test 'variable_pricing? returns true when amount_type is variable' do
    product = Product.new(amount_type: Product::AMOUNT_TYPE_VARIABLE)
    assert product.variable_pricing?
  end

  test 'variable_pricing? returns false when amount_type is not variable' do
    product = Product.new(amount_type: nil)
    assert_not product.variable_pricing?
  end

  test 'ordered scope orders by created_at ascending' do
    assert_equal Product.order(created_at: :asc).to_a, Product.ordered.to_a
  end

  test 'requires_booking reflects database column' do
    assert products(:one).requires_booking
    assert products(:two).requires_booking
    assert_not products(:three).requires_booking
  end

  test 'rejects product with neither external URL nor in-app booking' do
    product = Product.new(
      title: 'T',
      description: 'D',
      amount_type: Product::AMOUNT_TYPE_VARIABLE,
      external_url: nil,
      requires_booking: false
    )
    assert_not product.valid?
    assert_includes product.errors[:base], 'must provide an external booking URL or enable in-app booking'
  end

  test 'rejects product with both external URL and in-app booking' do
    product = Product.new(
      title: 'T',
      description: 'D',
      amount_type: Product::AMOUNT_TYPE_VARIABLE,
      external_url: 'https://example.com/book',
      requires_booking: true
    )
    assert_not product.valid?
    assert_includes product.errors[:base], 'cannot use both an external URL and in-app booking'
  end
end
