$: << File.expand_path("../../ext/noderb_http_extension", __FILE__)
$: << File.expand_path("../../lib", __FILE__)

require "noderb-http"

class TestParser

  include NodeRb::Modules::Http::Parser
  
  attr_accessor :headers, :version_major, :version_minor, :method, :url, :body, :keep_alive, :upgrade
  
  def on_message_header
  end
    
  def on_message_body
  end
  
  def on_message_error name, desc
    puts name
    puts desc
  end
  
end

def check_result parser, test
  errors = []
  errors << :http_major unless test[:http_major] == parser.version_major
  errors << :http_minor unless test[:http_minor] == parser.version_minor
  errors << :method unless test[:method] == parser.method
  errors << :request_url unless test[:request_url] == parser.url
  errors << :headers unless test[:headers] == parser.headers
  errors << :should_keep_alive unless test[:should_keep_alive] == parser.keep_alive
  errors << :body unless test[:body] == parser.body
  errors << :upgrade unless test[:upgrade] == parser.upgrade
  errors
end

CASES = []

Dir.glob(File.expand_path("../cases/*.rb", __FILE__)) do |file|
    require file
end

puts "** Testing noderb-http"
failed = false
CASES.each do |test|
  parser = TestParser.new
  parser.setup(test[:type])
  if test[:data].kind_of?(String)
    parser.parse(test[:data])
  else
    test[:data].each do |data|
      parser.parse(data)
    end
  end
  result = check_result(parser, test)
  if result.length > 0
    puts "** Test <#{test[:name]}> failed on #{result}" if result != "OK"
    failed = true
  end
end

puts "** All test passed OK" unless failed