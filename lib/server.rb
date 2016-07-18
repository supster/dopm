require 'socket'
require_relative './indexer'

class Server
  def start(port)
    @server = TCPServer.new(port)

    loop do
      Thread.new(@server.accept) do |socket|
        message = socket.gets

        if message == "PING\n"
          socket.puts "PONG\n"
        else
          socket.puts response(message)
        end
      end
    end
  end

  def response(message)
    package_indexer = Indexer.new
    status = package_indexer.perform(message)
  end
end