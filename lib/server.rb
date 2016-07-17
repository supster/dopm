require 'socket'

class Server
  def start(port)
    @server = TCPServer.new(port)

    loop do
      Thread.new(@server.accept) do |socket|
        if read = socket.gets
          message = read.chomp
        end

        if message == 'PING'
          socket.puts "PONG\n"
        end
      end
    end
  end

  def stop
    @server.close
  end
end