module Merb
  module Rack
    #This class will try to serve files form the spesified domain root for a given domain
    class MultiStatic < Merb::Rack::Middleware
      def initialize(app,domains)
        super(app)
        @file_servers = {}
        @roots = {}
        domains.keys.each do |domain|
          if domains[domain][:root]
            puts "Adding static route for \"#{domain}\" at:\n    #{domains[domain][:root]}"
            @file_servers[domain] =
                ::Rack::File.new(domains[domain][:root]) 
            @roots[domain] = domains[domain][:root]
          end
        end   
      end
      
      def call(env)
        path = if env[Merb::Const::PATH_INFO]
                 env[Merb::Const::PATH_INFO].chomp(Merb::Const::SLASH)
               else
                 Merb::Const::EMPTY_STRING
               end
        cached_path = (path.empty? ? 'index' : path) + '.html'
        
        domain = get_domain(env)
        return @app.call(env) unless @roots[domain]
        
        if file_exist_in_domain?(path,@roots[domain]) && env[Merb::Const::REQUEST_METHOD] =~ /GET|HEAD/ # Serve the file if it's there and the request method is GET or HEAD
          serve_from_domain(env,domain)
        elsif file_exist_in_domain?(cached_path,@roots[domain]) && env[Merb::Const::REQUEST_METHOD] =~ /GET|HEAD/ # Serve the page cache if it's there and the request method is GET or HEAD
          env[Merb::Const::PATH_INFO] = cached_path
          serve_from_domain(env,doamin)
        else
          @app.call(env)
        end
        
      end
      
      def serve_from_domain(env,domain)
        env[Merb::Const::PATH_INFO] = ::Merb::Parse.unescape(env[Merb::Const::PATH_INFO])
        @file_servers[domain].call(env)
      end
      
      def get_domain(env)
        host = env[Merb::Const::HTTP_X_FORWARDED_HOST] || env[Merb::Const::HTTP_HOST] ||
            env[Merb::Const::SERVER_NAME]
        host.sub(/:\d+$/,'')
      end
      
      def file_exist_in_domain?(path,root)
        full_path = ::File.join(root, ::Merb::Parse.unescape(path))
        ::File.file?(full_path) && ::File.readable?(full_path)
      end
    end
  end
end