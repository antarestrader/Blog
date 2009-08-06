Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  # RESTful routes
  resources :posts, :controller=>PostController
  resources :categories, :controller=>CategoryController
  
  match('/admin').to(:controller=>AdminController) do
    match('/').to(:action=>'index').name(:admin)
  end
  match('/',:query_string=>/p=\d+/).to(:controller => 'post_controller', :action =>'show', :id=>'[1]')
  
  #atom & rss feeds
  match('/feed/:action(.xml)').to(:controller=> 'feed_controller').name(:feeds)
  match('/',:query_string=>/feed=rss2/).to(:controller => 'feed_controller', :action =>'rss') #old wordpress format
  
  # Adds the required routes for merb-auth using the password slice
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")
  
  match('/static/:page').to(:controller => 'StaticController', :action=>'show').name(:static)
  # Change this for your home page to be available at /
  match('/(page/:page)').to(:controller => 'post_controller', :action =>'index').name(:home)
end