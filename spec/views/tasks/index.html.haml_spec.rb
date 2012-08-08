require 'spec_helper'

describe "tasks/index" do
  before(:each) do
    assign(:tasks, [
      stub_model(Task,
        :title => "Title",
        :description => "Description",
        :time_spent => 1,
        :time_estimated => 2,
        :user_id => 3,
        :tag_id => 4,
        :subtask_id => 5,
        :comment_id => 6
      ),
      stub_model(Task,
        :title => "Title",
        :description => "Description",
        :time_spent => 1,
        :time_estimated => 2,
        :user_id => 3,
        :tag_id => 4,
        :subtask_id => 5,
        :comment_id => 6
      )
    ])
  end

  it "renders a list of tasks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
  end
end
