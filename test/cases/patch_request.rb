CASES << {
    :name => "patch_request",
    :type => :request,
    :message_complete_on_eof => false,
    :data => [
      "PATCH /file.txt HTTP/1.1\n",
      "Host: www.example.com\n",
      "Content-Type: application/example\n",
      "If-Match: \"e0023aa4e\"\n",
      "Content-Length: 10\n",
      "\n",
      "abcde",
      "efghi"
    ],
    :should_keep_alive => true,
    :http_major => 1,
    :http_minor => 1,
    :method => "PATCH",
    :request_url => "/file.txt",
    :num_headers => 4,
    :headers => { 
        "Host" => "www.example.com",
        "Content-Length" => "10",
        "If-Match" => "\"e0023aa4e\"",
        "Content-Type" => "application/example"
    },
    :body => "abcdeefghi",
    :upgrade => false
}