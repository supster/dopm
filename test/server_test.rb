require 'socket'
require 'minitest/autorun'
require_relative '../lib/server'

HOST = 'localhost'
PORT = 8080

class Client
  def ping
    socket = TCPSocket.new(HOST, PORT)
    socket.puts 'PING'
    line = socket.gets
    socket.close
    line
  end
end

class ServerTest < Minitest::Test
  def test_ping_pong
    server = Server.new
    Thread.new do
      server.start(PORT)
    end

    client = Client.new
    assert_equal "PONG\n", client.ping
    server.stop
  end
end