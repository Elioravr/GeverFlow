require 'spec_helper'

describe "user_groups/edit" do
  before(:each) do
    @user_group = assign(:user_group, stub_model(UserGroup,
      :group_name => "MyString"
    ))
  end

  it "renders the edit user_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_groups_path(@user_group), :method => "post" do
      assert_select "input#user_group_group_name", :name => "user_group[group_name]"
    end
  end
end
