class Application < Merb::Controller
  before do
    @categories = Category.all
  end
end