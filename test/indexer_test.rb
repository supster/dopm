require 'minitest/autorun'
require_relative '../lib/indexer'

class IndexerTest < Minitest::Test
  def test_error_no_command
    indexer = Indexer.new
    message = "FOO|error|\n"
    assert_equal "ERROR\n", indexer.perform(message)
  end

  def test_error_bad_pattern
    indexer = Indexer.new
    message = "INDEX\n"
    assert_equal "ERROR\n", indexer.perform(message)
  end

  def test_error_blank
    indexer = Indexer.new
    message = ""
    assert_equal "ERROR\n", indexer.perform(message)
  end

  def test_ok_new_index
    indexer = Indexer.new
    message = "INDEX|ceylon|\n"
    assert_equal "OK\n", indexer.perform(message)
  end

  def test_fail
    indexer = Indexer.new
    message = "INDEX|ceylon|gmp\n"
    assert_equal "FAIL\n", indexer.perform(message)
  end

  def test_fail
    indexer = Indexer.new
    message = "INDEX|ceylon|gmp\n"
    assert_equal "FAIL\n", indexer.perform(message)
  end
end