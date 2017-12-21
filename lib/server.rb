require 'socket'
tcp_server = TCPServer.new(9292)
client = tcp_server.accept
request_count = 0
puts "Ready for a request"
request_lines = []
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end

puts "Sending response."
request_count += 1
vpp = request_lines[0].split(' ')
host_port = request_lines[1].split(' ').last.split(":")
formatted_response = ["Verb: #{vpp[0]}",
                      "Path: #{vpp[1]}",
                      "Protocol: #{vpp[2]}",
                      "Host: #{host_port[0]}",
                      "Port: #{host_port[1]}",
                      "Origin: #{host_port[0]}",
                      "Accept: #{request_lines[6]}"]
response = "<pre>" + formatted_response.join("\n") + "</pre>"
output = "<html><head></head><body>#{response}</body></html>\n<p>Hello World! (#{request_count})</p>"
headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
client.puts headers
client.puts output



puts ["Wrote this response:", headers, output].join("\n")
client.close
puts "\nResponse complete, exiting."
