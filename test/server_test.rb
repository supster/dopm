require 'socket'
require 'minitest/autorun'
require_relative '../lib/server'

HOST = 'localhost'
PORT = 8080

class Client
  def request(message)
    socket = TCPSocket.new(HOST, PORT)
    socket.puts message
    line = socket.gets
    socket.close
    line
  end
end

class ServerTest < Minitest::Test
  def test_ping_pong
    thr = Thread.new do
      Server.new.start(PORT)
    end

    client = Client.new
    assert_equal "PONG\n", client.request("PING\n")
    thr.kill
  end
end