require "rack"
require "stringio"
require "noderb/modules/http/parser"

module NodeRb
  module Modules
    module Http
      class RackParser

        include Parser

        def initialize(env)
          setup(:request)
          @env = {
              "rack.input" => StringIO.new,
              "rack.version" => ::Rack::VERSION,
              "rack.errors" => StringIO.new,
              "rack.multithread" => false,
              "rack.multiprocess" => false,
              "rack.run_once" => false,
              "rack.url_scheme" => "http"
          }.merge(env || {})
        end

        def <<(data)
          self.parse(data)
          return nil unless @_state == :done
          self.dispose
          @env
        end

        def on_message_begin
          @_state = :field
          @_header_name = ""
          @_header_value = ""
        end

        def on_method(method)
          @env["REQUEST_METHOD"] = method
        end

        def on_url(url)
          url = url.split("?", 2)
          if @env["SCRIPT_NAME"]
            url.sub!(@env["SCRIPT_NAME"], "")
          else
            @env["SCRIPT_NAME"] = ""
          end
          @env["PATH_INFO"] = url[0]
          @env["QUERY_STRING"] = url[1] || ""
        end

        def on_header_field(name)
          if @_state == :value
            header = @_header_name.sub("-", "_").upcase
            case header
              when "CONTENT_TYPE", "CONTENT_LENGTH"
                @env[header] = @_header_value
              when "HOST"
                @env["HTTP_HOST"] = @_header_value
                unless @env["SERVER_NAME"]
                  host = @_header_value.split(":")
                  @env["SERVER_NAME"] = host[0]
                  @env["SERVER_PORT"] = host[1] || 80
                end
              else
                @env["HTTP_#{header}"] = @_header_value
            end
            @_header_name = ""
            @_header_value = ""
          end
          @_state = :field
          @_header_name << name
        end

        def on_header_value(value)
          @_header_value << value
          @_state = :value
        end

        def on_headers_complete
          on_header_field("")
        end

        def on_body(body)
          @env["rack.input"] << body
        end

        def on_error(name, description)
          raise(RuntimeError, "Http parser error: #{name} (#{description})")
        end

        def on_keep_alive status
          @env["nrb.keep_alive"] = status
        end

        def on_upgrade
          @env["nrb.upgrade"] = true
        end

        def on_message_complete
          @_state = :done
        end

      end
    end
  end
end