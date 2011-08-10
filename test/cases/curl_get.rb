CASES << {
    :name => "curl_get",
    :type => :request,
    :message_complete_on_eof => false,
    :data => [
      "GET /test HTTP/1.1\n",
      "User-Agent: curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1\n",
      "Host: 0.0.0.0=5000\n",
      "Accept: */*\n",
      "\n"
    ],    
    :should_keep_alive => true,
    :http_major => 1,
    :http_minor => 1,
    :method => "GET",
    :request_url => "/test",
    :num_headers => 3,
    :headers => { 
        "User-Agent" => "curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1",
        "Host" => "0.0.0.0=5000",
        "Accept" => "*/*",
    },
    :body => "",
    :upgrade => false
}