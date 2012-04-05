require 'test_helper'

class TaskInventoriesControllerTest < ActionController::TestCase
  setup do
    @task_inventory = task_inventories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:task_inventories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task_inventory" do
    assert_difference('TaskInventory.count') do
      post :create, task_inventory: { name: @task_inventory.name }
    end

    assert_redirected_to task_inventory_path(assigns(:task_inventory))
  end

  test "should show task_inventory" do
    get :show, id: @task_inventory
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task_inventory
    assert_response :success
  end

  test "should update task_inventory" do
    put :update, id: @task_inventory, task_inventory: { name: @task_inventory.name }
    assert_redirected_to task_inventory_path(assigns(:task_inventory))
  end

  test "should destroy task_inventory" do
    assert_difference('TaskInventory.count', -1) do
      delete :destroy, id: @task_inventory
    end

    assert_redirected_to task_inventories_path
  end
end
