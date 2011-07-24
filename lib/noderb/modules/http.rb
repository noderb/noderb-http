module NodeRb
  module Modules
    module Http

      module Rack

        def initialize
          @env = {}
        end

        def on_header name, value
        end

      end

      class Parser

        def on_message_begin
        end

        def on_method method
        end

        def on_path path
        end

        def on_query_string query_string
        end

        def on_url url
        end

        def on_fragment fragment
        end

        def on_header_field_internal name
          if @_header_state == :value
            on_header_value(@_header_value)
            on_header(@_header_name, @_header_value)
            @_header_name = nil
            @_header_value = nil
          end
          @_header_state = :field
          @_header_name ||= ""
          @_header_name << name
        end

        def on_header_field name
          
        end

        def on_header_value_internal value
          if @_header_state == :field
            on_header_field(@_header_name)
          end
          @_header_state = :value
          @_header_value ||= ""
          @_header_value << value
        end

        def on_header_value value

        end

        def on_header name, value
        end

        def on_headers_complete_internal
          on_header_value(@_header_value)
          on_header(@_header_name, @_header_value)
          @_header_name = nil
          @_header_value = nil
          on_headers_complete
        end

        def on_headers_complete
          
        end

        def on_close_keep_alive
        end

        def on_upgrade
        end

        def on_body body
        end

        def on_message_complete
        end

        def on_error
        end

      end

    end
  end
end