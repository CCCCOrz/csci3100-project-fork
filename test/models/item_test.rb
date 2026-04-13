require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "search filters by keyword across item fields and seller names" do
    results = Item.search(keyword: "alice")

    assert_includes results, items(:one)
    assert_includes results, items(:three)
    assert_not_includes results, items(:two)
  end

  test "search supports fuzzy matching for minor typos" do
    results = Item.search(keyword: "iphnoe")

    assert_includes results, items(:three)
    assert_not_includes results, items(:two)
  end

  test "search filters by category status and price range" do
    results = Item.search(
      category: "electronics",
      status: "available",
      min_price: 4000,
      max_price: 4500
    )

    assert_equal [ items(:one) ], results.to_a
  end

  test "search filters by seller location and recent posting window" do
    travel_to Date.new(2026, 4, 6) do
      results = Item.search(
        seller_location: "United College",
        posted_within_days: 7,
        sort: "newest"
      )

      assert_equal [ items(:four), items(:two) ], results.to_a
    end
  end

  test "search sorts results by ascending price" do
    results = Item.search(category: "furniture", sort: "price_low_to_high")

    assert_equal [ items(:four), items(:five) ], results.to_a
  end

  test "autocomplete returns title suggestions by prefix" do
    suggestions = Item.autocomplete("iP")

    assert_equal [ "iPad Pro", "iPhone 13" ], suggestions
  end

  test "autocomplete can recover from a small typo" do
    suggestions = Item.autocomplete("iphne")

    assert_includes suggestions, "iPhone 13"
  end

  test "should save item with all required fields" do
    item = Item.new(
      name: "Test Laptop",
      description: "A brand new laptop for sale",
      category: "electronics",
      price: 999,
      seller: users(:one) 
    )

    assert item.save          
    assert_empty item.errors  
  end

  test "should not save item without name" do
    item = Item.new(
      description: "A brand new laptop for sale",
      category: "electronics",
      price: 999,
      seller: users(:one)
    )

    assert_not item.save
    assert_includes item.errors[:name], "can't be blank" 
  end

  test "should not save item without description" do
    item = Item.new(
      name: "Test Laptop",
      category: "electronics",
      price: 999,
      seller: users(:one)
    )

    assert_not item.save
    assert_includes item.errors[:description], "can't be blank"
  end

  test "should not save item without category" do
    item = Item.new(
      name: "Test Laptop",
      description: "A brand new laptop for sale",
      price: 999,
      seller: users(:one)
    )

    assert_not item.save
    assert_includes item.errors[:category], "can't be blank"
  end

  test "should not save item with invalid price" do
    item1 = Item.new(
      name: "Test Laptop", description: "Test", category: "electronics",
      seller: users(:one)
    )
    assert_not item1.save
    assert_includes item1.errors[:price], "can't be blank"

    item2 = Item.new(
      name: "Test Laptop", description: "Test", category: "electronics",
      price: 0, seller: users(:one)
    )
    assert_not item2.save
    assert_includes item2.errors[:price], "must be greater than 0"

    item3 = Item.new(
      name: "Test Laptop", description: "Test", category: "electronics",
      price: -100, seller: users(:one)
    )
    assert_not item3.save
    assert_includes item3.errors[:price], "must be greater than 0"
  end
  
end
