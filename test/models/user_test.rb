# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'encrypts first_name and last_name' do
    assert_includes User.encrypted_attributes, :first_name
    assert_includes User.encrypted_attributes, :last_name
  end

  test 'encrypts email deterministically' do
    assert_includes User.encrypted_attributes, :email
    assert_includes User.deterministic_encrypted_attributes, :email
  end

  test 'requires first_name' do
    user = users(:one)
    user.first_name = nil

    assert_not user.valid?
    assert_includes user.errors[:first_name], "can't be blank"
  end

  test 'requires last_name' do
    user = users(:one)
    user.last_name = nil

    assert_not user.valid?
    assert_includes user.errors[:last_name], "can't be blank"
  end

  test 'requires email' do
    user = users(:one)
    user.email = nil

    assert_not user.valid?
    assert user.errors[:email].any?, 'expected errors on email'
  end
end
