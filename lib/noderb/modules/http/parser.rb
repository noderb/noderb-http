module NodeRb
  module Modules
    module Http

      module Parser

        def on_message_begin
          @_header_name = ""
          @_header_value = ""
          @headers = {}
          @body = ""
          @method = ""
          @url = ""
          @status_code = 0
          @upgrade = false
          @keep_alive = false
          @_active = true
        end
        
        def on_method method
          @method = method
        end

        def on_url url
          @url = url
        end

        def on_header_field name
          if @_header_state == :value
            on_header(@_header_name, @_header_value)
            @_header_name = ""
            @_header_value = ""
          end
          @_header_state = :field
          @_header_name << name
        end

        def on_header_value value
          @_header_state = :value
          @_header_value ||= ""
          @_header_value << value
        end

        def on_header name, value
          @headers[name] = value if @_active
        end
        
        def on_version major, minor
          @version_major = major if @_active
          @version_minor = minor if @_active
        end
        
        def on_status_code status_code
          @status_code = status_code if @_active
        end
        
        def on_keep_alive keep_alive
          @keep_alive = keep_alive if @_active
        end

        def on_headers_complete
          on_header(@_header_name, @_header_value)
          @_header_name = ""
          @_header_value = ""
          on_message_header
        end

        def on_upgrade
          @_active = false
          @upgrade = true
        end

        def on_body body
          @body << body if @_active
        end
        
        def on_message_complete
          on_message_body
        end
        
        def on_error name, description
          @_active = true
          on_message_error(name, description)
        end
        
        def on_message_header
          # User overrides this to get whole message header
          # ------
          # @headers => Hash
          # @url => String
          # @version_major => Integer
          # @version_minor => Integer
          # @status_code (response) => Integer
          # @method (request) => String
          # @upgrade => Boolean
          # @keep_alive => Boolean
        end
        
        def on_message_body
          # User overrides this to get whole message body
          # @body => String
        end

        def on_message_error name, description
          # User overrides this to be notified of errors
        end

      end

    end
  end
end