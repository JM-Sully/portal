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

  test 'ordered scope sorts by DISPLAY_ORDER' do
    Product.destroy_all
    walk = Product.create!(title: 'A guided Lowland Walk', description: 'Walk')
    talk = Product.create!(title: 'Conference Talk', description: 'Talk')
    dog = Product.create!(title: 'Dog Sitting', description: 'Dog')

    assert_equal [talk, walk, dog], Product.ordered.to_a
  end
end
