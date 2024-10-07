require "test_helper"

class MeetingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @meeting = meetings(:one)
  end

  test "should get new" do
    get new_meeting_url
    assert_response :success
  end

  test "should create meeting" do
    assert_difference("Meeting.count") do
      post meetings_url, params: { meeting: { day: @meeting.day, how: @meeting.how, when: @meeting.when } }
    end

    assert_redirected_to meeting_url(Meeting.last)
  end

  test "should get edit" do
    get edit_meeting_url(@meeting)
    assert_response :success
  end

  test "should update meeting" do
    patch meeting_url(@meeting), params: { meeting: { day: @meeting.day, how: @meeting.how, when: @meeting.when } }
    assert_redirected_to meeting_url(@meeting)
  end

end
