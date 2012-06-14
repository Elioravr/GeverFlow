require 'spec_helper'

describe "user_groups/index" do
  before(:each) do
    assign(:user_groups, [
      stub_model(UserGroup,
        :group_name => "Group Name"
      ),
      stub_model(UserGroup,
        :group_name => "Group Name"
      )
    ])
  end

  it "renders a list of user_groups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Group Name".to_s, :count => 2
  end
end
