module Merb
  module Rack
    #This class will try to serve files form the spesified domain root for a given domain
    class MultiStatic < Merb::Rack::Middleware
      def initialize(app,domains)
        super(app)
        @file_servers = {}
        @roots = {}
        domains.each do |domain|
          if domain.public_root
            puts "Adding static route for \"#{domain.domain_name}\" at:\n    #{domain.public_root}"
            @file_servers[domain.domain_name] =
                ::Rack::File.new(domain.public_root) 
            @roots[domain.domain_name] = domain.public_root
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
          serve_from_domain(env,domain)
        else
          @app.call(env)
        end
        
      rescue
        [500,{'Content-Type'=>'text/text'},'Rack Multistatic Internal Error']
      end
      
      def serve_from_domain(env,domain)
        env[Merb::Const::PATH_INFO] = ::Merb::Parse.unescape(env[Merb::Const::PATH_INFO])
        @file_servers[domain].call(env)
      end
      
      def get_domain(env)
        host = env[Merb::Const::HTTP_X_FORWARDED_HOST] || env[Merb::Const::HTTP_HOST] ||
            env[Merb::Const::SERVER_NAME]
        host.sub(/:\d+$/,'') #remove port if it exists
      end
      
      def file_exist_in_domain?(path,root)
        full_path = ::File.join(root, ::Merb::Parse.unescape(path))
        ::File.file?(full_path) && ::File.readable?(full_path)
      end
    end
  end
  
  module Cache
    class MultiStore < ActionStore
      def initialize(config={})
        @domain = config[:domain]
        super
      end
      
      def writable?(dispatch, parameters = {}, conditions = {})
        str = "Checking writablility:\n"
        str << [dispatch.class.to_s, dispatch.request.method, dispatch.request.uri].join(', ') << "\n"
        str << parameters.inspect << "\n"
        str << conditions.inspect << "\n"
        if Merb::Controller === dispatch && dispatch.request.domain(5) == @domain
          ret = @stores.any? {|s| s.writable?(normalize(dispatch), parameters, conditions)}
          str << (ret ? "Succeeded\n" : "Faild with decendents\n")
          Merb.logger.debug str
        else
          str << "Faild with me\n"
          Merb.logger.debug str
          false
        end
      end
      
      def normalize(dispatch)
        dispatch
      end
    end
  end
end

