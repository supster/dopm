require 'socket'
require_relative './indexer'

class Server
  def start(port)
    puts "running on #{port}"
    server = TCPServer.new(port)
    @package_indexer = Indexer.new

    mutex = Mutex.new
    loop do
      Thread.new(server.accept) do |socket|
        Thread.new do
          loop do
            message = socket.gets
            mutex.synchronize do
              socket.puts response(message)
            end
          end
        end
      end
    end
  end

  def response(message)
    @package_indexer.perform(message)
  end
end