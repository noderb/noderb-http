CASES << {
    :name => "upgrade request",
    :type => :request,
    :message_complete_on_eof => false,
    :data => [
      "GET /demo HTTP/1.1\n",
      "Host: example.com\n",
      "Connection: Upgrade\n",
      "Sec-WebSocket-Key2: 12998 5 Y3 1  .P00\n",
      "Sec-WebSocket-Protocol: sample\n",
      "Upgrade: WebSocket\n",
      "Sec-WebSocket-Key1: 4 @1  46546xW%0l 1 5\n",
      "Origin: http://example.com\n",
      "\n",
      "Hot diggity dogg"
    ],    
    :should_keep_alive => true,
    :http_major => 1,
    :http_minor => 1,
    :method => "GET",
    :request_url => "/demo",
    :num_headers => 7,
    :headers => { 
      "Host" => "example.com",
      "Connection" => "Upgrade",
      "Sec-WebSocket-Key2" => "12998 5 Y3 1  .P00",
      "Sec-WebSocket-Protocol" => "sample",
      "Upgrade" => "WebSocket",
      "Sec-WebSocket-Key1" => "4 @1  46546xW%0l 1 5",
      "Origin" => "http://example.com"
    },
    :upgrade => true,
    :body => ""
}