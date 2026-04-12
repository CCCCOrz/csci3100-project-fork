require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "TestUser",
      email: "test@link.cuhk.edu.hk",
      password: "password123",
      password_confirmation: "password123"
    )
    @item = Item.create!(
      name: "TestItem",
      price: 99.99,
      description: "Test item for favorite function",
      seller_id: @user.id
    )
  end

  test "user can successfully favorite an item" do
    favorite = @user.favorites.create!(item: @item)
    assert favorite.valid?
    assert_includes @user.favorite_items, @item
  end

  test "user can successfully unfavorite an item" do
    favorite = @user.favorites.create!(item: @item)
    favorite.destroy
    assert_not_includes @user.favorite_items, @item
  end

  test "prevents duplicate favorites for the same user and item" do
    @user.favorites.create!(item: @item)
    duplicate_favorite = @user.favorites.build(item: @item)
    assert_not duplicate_favorite.valid?
    assert_includes duplicate_favorite.errors.full_messages.to_s, "can only favorite an item once"
  end
end
