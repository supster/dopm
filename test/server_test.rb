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
    assert_equal "PONG\n", client.request('PING')
    thr.kill
  end

  def test_response_error
    server = Server.new
    message = "FOO|error|\n"
    assert_equal "ERROR\n", server.response(message)
  end

  def test_response_ok
    server = Server.new
    message = "INDEX|ceylon|\n"
    assert_equal "OK\n", server.response(message)
  end

  def test_fail
    server = Server.new
    message = "INDEX|ceylon|gmp\n"
    assert_equal "FAIL\n", server.response(message)
  end
end