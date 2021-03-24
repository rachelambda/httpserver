require 'socket'

class HTTPHeader

  attr_accessor :headers, :body

  def initialize(first_line, headers={}, body="")
    @headers=headers
    @first_line = first_line
    @body = body
  end

  def body
    @first_line + "\nContent-Length: #{@body.length}\n" + @headers.keys.map do |key|
      "#{key}: #{@headers[key]}"
    end.join("\n") + "\n\n" + @body
  end
end

class HTTPRequest < HTTPHeader
  def initialize(method, path, headers={}, body="")
    super("#{method} #{path} HTTP/1.1", headers, body)
  end
end

class Integer
  def to_HTTPStatus
  {
    100 => '100 Continue',
    101 => '101 Switching protocols',
    102 => '102 Processing',
    103 => '103 Early Hints',
    200 => '200 OK',
    201 => '201 Created',
    202 => '202 Accepted',
    203 => '203 Non-Authorative Infromation',
    204 => '204 No Content',
    205 => '205 Reset Content',
    206 => '206 Partial Content',
    207 => '207 Multi-Status',
    208 => '208 Already Reported',
    226 => '226 IM Used',
    300 => '300 Multiple Choices',
    301 => '301 Moved Permanently',
    302 => '302 Found',
    303 => '303 See Other',
    304 => '304 Not Modified',
    305 => '305 Use Proxy',
    306 => '306 Switch Proxy',
    307 => '307 Temporary Redirect',
    308 => '308 Permanent Redirect',
    400 => '400 Bad Request',
    401 => '401 Unauthorized',
    402 => '402 Payment Required',
    403 => '403 Forbidden',
    404 => '404 Not Found',
    405 => '405 Method Not Allowed',
    406 => '406 Not Acceptable',
    407 => '407 Proxy Authentication Required',
    408 => '408 Request Timeout',
    409 => '409 Conflict',
    410 => '410 Gone',
    412 => '412 Precondition Failed',
    413 => '413 Payload Too Large',
    414 => '414 URI Too Long',
    415 => '415 Unsupported Media Type',
    416 => '416 Range Not Satisfiable',
    417 => '417 Expectation Failed',
    418 => "418 I'm a teapot",
    421 => '421 Misdirected Request',
    422 => '422 Unprocessable Entity',
    423 => '423 Locked',
    424 => '424 Failed Dependency',
    425 => '425 Too Early',
    426 => '426 Upgrade Required',
    428 => '428 Precondition Required',
    429 => '429 Too Many Requests',
    431 => '431 Request Header Fields Too Large',
    451 => '451 Unavailable For Legal Reasons',
    500 => '500 Internal Server Error',
    501 => '501 Not Implemented',
    502 => '502 Bad Gateway',
    503 => '503 Service Unavailable',
    504 => '504 Gateway Timeout',
    505 => '505 HTTP Version Not Supported',
    506 => '506 Variant Also Negotiates',
    507 => '507 Insufficient Storage',
    508 => '508 Loop Detected',
    510 => '510 Not Extended',
    511 => '511 Network Authentication Required',
  }.freeze[self]
  end
end

class HTTPResponse < HTTPHeader
  def initialize(code, headers={}, body="")
    super("HTTP/1.1 #{code.to_HTTPStatus}", headers, body)
  end
end

server = TCPServer.new 8080
STDERR.puts "Listening on port 8080"

while session = server.accept
  session.write HTTPResponse.new(200, { "Content-Type" => "text/html" }, "<h1>TEST RESPONSE</h1>").body
end
