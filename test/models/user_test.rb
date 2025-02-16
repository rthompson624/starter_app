require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @valid_attributes = {
      email: "unique_test@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
  end

  test "should create user with valid attributes" do
    user = User.new(@valid_attributes)
    assert user.valid?
    assert user.save
  end

  test "should not create user without email" do
    user = User.new(@valid_attributes.merge(email: ""))
    assert_not user.save
  end

  test "should not create user with invalid email format" do
    user = User.new(@valid_attributes.merge(email: "invalid_email"))
    assert_not user.save
  end

  test "should not create user with short password" do
    user = User.new(@valid_attributes.merge(
      password: "pass",
      password_confirmation: "pass"
    ))
    assert_not user.save
  end

  test "should not create user with mismatched password confirmation" do
    user = User.new(@valid_attributes.merge(
      password_confirmation: "different123"
    ))
    assert_not user.save
  end
end
