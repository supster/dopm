require 'socket'

class Server
  def initialize
    @data_store = {}
  end

  def start(port)
    @server = TCPServer.new(port)

    loop do
      Thread.new(@server.accept) do |socket|
        message = socket.gets

        if message == 'PING'
          socket.puts "PONG\n"
        else
          socket.puts response(message)
        end
      end
    end
  end

  COMMANDS = ['INDEX', 'REMOVE', 'QUERY']

  def response(message)
    command, package, dependencies = message.chomp.split('|')

    if !COMMANDS.include?(command)
      status = "ERROR\n"
    else
      if !dependencies.nil?
        dependencies.split(',').each do |dependency|
          if !@data_store.has_key?(dependency)
            status = "FAIL\n"
            break
          end
        end
      else
        status = "OK\n"
      end
    end

    status
  end
end