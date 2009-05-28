require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/post_controller" do
  before(:each) do
    @response = request("/post_controller")
  end
end