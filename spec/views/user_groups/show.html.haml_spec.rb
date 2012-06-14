require 'spec_helper'

describe "user_groups/show" do
  before(:each) do
    @user_group = assign(:user_group, stub_model(UserGroup,
      :group_name => "Group Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Group Name/)
  end
end
