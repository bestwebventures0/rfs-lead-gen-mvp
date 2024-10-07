require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "should get validate_otp" do
    get confirmations_validate_otp_url
    assert_response :success
  end

  test "should get resend_otp" do
    get confirmations_resend_otp_url
    assert_response :success
  end
end
