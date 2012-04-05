require 'test_helper'

class PaidTimeEntriesControllerTest < ActionController::TestCase
  setup do
    @paid_time_entry = paid_time_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paid_time_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paid_time_entry" do
    assert_difference('PaidTimeEntry.count') do
      post :create, paid_time_entry: { effective_date: @paid_time_entry.effective_date, time: @paid_time_entry.time }
    end

    assert_redirected_to paid_time_entry_path(assigns(:paid_time_entry))
  end

  test "should show paid_time_entry" do
    get :show, id: @paid_time_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @paid_time_entry
    assert_response :success
  end

  test "should update paid_time_entry" do
    put :update, id: @paid_time_entry, paid_time_entry: { effective_date: @paid_time_entry.effective_date, time: @paid_time_entry.time }
    assert_redirected_to paid_time_entry_path(assigns(:paid_time_entry))
  end

  test "should destroy paid_time_entry" do
    assert_difference('PaidTimeEntry.count', -1) do
      delete :destroy, id: @paid_time_entry
    end

    assert_redirected_to paid_time_entries_path
  end
end
