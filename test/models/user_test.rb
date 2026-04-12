require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes legacy college locations to full english names" do
    user = User.new(
      name: "daisy",
      email: "daisy@link.cuhk.edu.hk",
      location: "new asia",
      password: "password123",
      password_confirmation: "password123"
    )

    user.valid?

    assert_equal "New Asia College", user.location
  end
end
