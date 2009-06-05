require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/category_controller" do
  before(:each) do
    @response = request("/category_controller")
  end
end