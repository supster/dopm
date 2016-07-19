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
  def test_simple_request
    indexer = MiniTest::Mock.new
    indexer.expect(:perform, "OK\n", ["INDEX|foo|\n"])

    Thread.new do
      server = Server.new(indexer).start(PORT)
    end

    client = Client.new
    assert_equal "OK\n", client.request("INDEX|foo|\n")
  end
end