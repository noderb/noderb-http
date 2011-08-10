CASES << {
    :name => "response",
    :type => :response,
    :message_complete_on_eof => false,
    :data => [
      "HTTP/1.0 301 Moved Permanently\n",
      "Date: Thu, 03 Jun 2010 09:56:32 GMT\n",
       "Server: Apache/2.2.3 (Red Hat)\n",
      "Cache-Control: public\n",
      "Pragma: \n",
      "Location: http://www.bonjourmadame.fr/\n",
      "Vary: Accept-Encoding\n",
      "Content-Length: 0\n",
      "Content-Type: text/html; charset=UTF-8\n",
      "Connection: keep-alive\n",
      "\n"
    ],    
    :should_keep_alive => true,
    :http_major => 1,
    :http_minor => 0,
    :method => "",
    :request_url => "",
    :num_headers => 9,
    :status_code => 301,
    :headers => { 
      "Date" => "Thu, 03 Jun 2010 09:56:32 GMT",
      "Server" => "Apache/2.2.3 (Red Hat)",
      "Cache-Control" => "public",
      "Pragma" => "",
      "Location" => "http://www.bonjourmadame.fr/",
      "Vary" => "Accept-Encoding",
      "Content-Length" => "0",
      "Content-Type" => "text/html; charset=UTF-8",
      "Connection" => "keep-alive"
    },
    :upgrade => false,
    :body => ""
}