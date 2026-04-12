require "test_helper"

class AnalyticsControllerTest < ActionDispatch::IntegrationTest
  test "should get interactive dashboard" do
    get analytics_url

    assert_response :success
    assert_select "h1", text: "Interactive Dashboard"
    assert_select "[data-controller='analytics-dashboard']", 1
    assert_select "canvas", 5
  end
end
