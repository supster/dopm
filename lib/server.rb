require 'socket'
require_relative './indexer'

class Server
  def initialize(package_indexer)
    @package_indexer = package_indexer
  end

  def start(port)
    puts "running on #{port}"
    server = TCPServer.new(port)
    mutex = Mutex.new

    listen_to_command_key

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

  def listen_to_command_key
    Thread.new do
      loop do
        c = gets.chomp
        if c == 'Q'
          puts 'Save data and exit'
          @package_indexer.save_data_to_file
          exit
        elsif c == 'S'
          puts 'Save data'
          @package_indexer.save_data_to_file
        end
      end
    end
  end

  def response(message)
    @package_indexer.perform(message)
  end
end