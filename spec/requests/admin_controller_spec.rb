require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/admin_controller" do
  before(:each) do
    @response = request("/admin_controller")
  end
end