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

  test 'requires unique email case-insensitively' do
    User.create!(
      first_name: 'Jane',
      last_name: 'Doe',
      email: 'duplicate@example.com',
      password: 'password123'
    )
    duplicate = User.new(
      first_name: 'Other',
      last_name: 'Person',
      email: 'DUPLICATE@example.com',
      password: 'password123'
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], 'has already been taken'
  end

  test 'rejects invalid email formats' do
    user = users(:one)

    %w[plaintext user@ @domain.com user@.com].each do |bad_email|
      user.email = bad_email
      assert_not user.valid?, "#{bad_email} should be invalid"
      assert user.errors[:email].any?, "expected email error for #{bad_email}"
    end
  end

  test 'accepts valid email formats' do
    user = users(:one)

    %w[user@example.com first.last@domain.co user+tag@example.org].each do |good_email|
      user.email = good_email
      assert user.valid?, "#{good_email} should be valid but got: #{user.errors.full_messages}"
    end
  end
end
