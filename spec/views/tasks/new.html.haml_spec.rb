require 'spec_helper'

describe "tasks/new" do
  before(:each) do
    assign(:task, stub_model(Task,
      :title => "MyString",
      :description => "MyString",
      :time_spent => 1,
      :time_estimated => 1,
      :user_id => 1,
      :tag_id => 1,
      :subtask_id => 1,
      :comment_id => 1
    ).as_new_record)
  end

  it "renders new task form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tasks_path, :method => "post" do
      assert_select "input#task_title", :name => "task[title]"
      assert_select "input#task_description", :name => "task[description]"
      assert_select "input#task_time_spent", :name => "task[time_spent]"
      assert_select "input#task_time_estimated", :name => "task[time_estimated]"
      assert_select "input#task_user_id", :name => "task[user_id]"
      assert_select "input#task_tag_id", :name => "task[tag_id]"
      assert_select "input#task_subtask_id", :name => "task[subtask_id]"
      assert_select "input#task_comment_id", :name => "task[comment_id]"
    end
  end
end
