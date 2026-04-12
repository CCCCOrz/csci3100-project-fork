require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should filter items on index" do
    get items_url, params: {
      keyword: "phone",
      category: "electronics",
      status: "reserved"
    }

    assert_response :success
    assert_select ".item-card", 1
    assert_select ".card-title", text: "iPhone 13"
    assert_select ".card-title", text: "iPad Pro", count: 0
    assert_select ".card-title", text: "Microeconomics Textbook", count: 0
  end

  test "should filter items by community and sort by price" do
    get items_url, params: {
      seller_location: "United College",
      sort: "price_low_to_high"
    }

    assert_response :success
    assert_select ".item-card", 2
    assert_select ".card-title", text: "Microeconomics Textbook"
    assert_select ".card-title", text: "Desk Lamp"
    assert_select ".card-title", text: "Gaming Chair", count: 0
  end

  test "should return autocomplete suggestions as json" do
    get autocomplete_items_url, params: { q: "iP" }, as: :json

    assert_response :success
    assert_equal [ "iPad Pro", "iPhone 13" ], JSON.parse(@response.body)
  end

  test "should return typo tolerant autocomplete suggestions as json" do
    get autocomplete_items_url, params: { q: "iphne" }, as: :json

    assert_response :success
    assert_includes JSON.parse(@response.body), "iPhone 13"
  end
end
