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
  @@server_thread = Thread.new do
    @server = Server.new.start(PORT)
  end

  def test_simple_request
    client = Client.new
    assert_equal "OK\n", client.request("INDEX|foo|\n")
  end

  def test_error
    client = Client.new
    assert_equal "ERROR\n", client.request("I|a|b")
  end
end