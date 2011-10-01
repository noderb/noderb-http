#$: << File.expand_path("../../ext/noderb_http_extension", __FILE__)
#$: << File.expand_path("../../lib", __FILE__)

require "rubygems"

require "noderb-http"

require "eventmachine"
require "rack/lint"

class App
  def self.call(env)
    [200, {"Content-Type" => "text/html"}, "Hello"]
  end
end

class Server < EventMachine::Connection

  def post_init
    @env = {}
    @parser = ::NodeRb::Modules::Http::RackParser.new(@env)
    @app = ::Rack::Lint.new(App)
  end

  def receive_data data
    result = (@parser << data)
    if result
      puts result.inspect
      send_data(@app.call(result)[2].inspect)
      close_connection_after_writing
    end
  end

  def unbind
    @env = nil
    @parser = nil
  end

end

EventMachine.run do
  EventMachine.start_server "0.0.0.0", 8080, Server
end
