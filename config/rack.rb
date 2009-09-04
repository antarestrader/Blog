# use PathPrefix Middleware if :path_prefix is set in Merb::Config
if prefix = ::Merb::Config[:path_prefix]
  use Merb::Rack::PathPrefix, prefix
end

# comment this out if you are running merb behind a load balancer
# that serves static files

require 'multistatic'

if Domain.storage_exists? && Merb::Config[:multidomain]
  use Merb::Rack::MultiStatic, Domain.all
end
use Merb::Rack::Static, Merb.dir_for(:public)

# this is our main merb application
run Merb::Rack::Application.new