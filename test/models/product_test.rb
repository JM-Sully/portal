# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'requires title' do
    product = Product.new(description: 'Test description')
    assert_not product.valid?
    assert_includes product.errors[:title], "can't be blank"
  end

  test 'requires description' do
    product = Product.new(title: 'Test Title')
    assert_not product.valid?
    assert_includes product.errors[:description], "can't be blank"
  end

  test 'valid with title and description' do
    product = Product.new(title: 'Test Title', description: 'Test description')
    assert product.valid?
  end

  test 'variable_pricing? returns true when amount_type is variable' do
    product = products(:one)
    product.update(amount_type: Product::AMOUNT_TYPE_VARIABLE)
    assert product.variable_pricing?
  end

  test 'variable_pricing? returns false when amount_type is nil' do
    product = products(:one)
    product.update(amount_type: nil)
    assert_not product.variable_pricing?
  end

  test 'ordered scope orders by created_at ascending' do
    Product.destroy_all
    product1 = Product.create!(title: 'First', description: 'First product')
    product2 = Product.create!(title: 'Second', description: 'Second product')

    assert_equal [product1, product2], Product.ordered.to_a
  end
end
