require 'minitest/autorun'
require_relative '../lib/indexer'

class IndexerTest < Minitest::Test
  def setup
    @indexer = Indexer.new
  end

  def test_error_no_command
    message = "FOO|error|\n"
    assert_equal "ERROR\n", @indexer.perform(message)
  end

  def test_error_bad_pattern
    message = "INDEX\n"
    assert_equal "ERROR\n", @indexer.perform(message)

    message = "REMOVE|\n"
    assert_equal "ERROR\n", @indexer.perform(message)
  end

  def test_error_blank
    message = ""
    assert_equal "ERROR\n", @indexer.perform(message)
  end

  def test_ok_index_new
    message = "INDEX|ceylon|\n"
    assert_equal "OK\n", @indexer.perform(message)
  end

  def test_ok_index_package_exist
    message = "INDEX|ceylon|\n"
    @indexer.perform(message)

    assert_equal "OK\n", @indexer.perform(message)
  end

  def test_ok_index_dependencies_exist
    message = "INDEX|ceylon|\n"
    @indexer.perform(message)

    message = "INDEX|bar|ceylon\n"
    assert_equal "OK\n", @indexer.perform(message)
  end

  def test_fail_index_dependencies_not_exist
    message = "INDEX|ceylon|gmp\n"
    assert_equal "FAIL\n", @indexer.perform(message)
  end

  def test_ok_remove
    message = "INDEX|foo|\n"
    @indexer.perform(message)

    message = "REMOVE|foo|\n"
    assert_equal "OK\n", @indexer.perform(message)
  end

  def test_ok_remove_not_exist
    message = "REMOVE|foo|\n"

    assert_equal "OK\n", @indexer.perform(message)
  end

  def test_fail_remove_dependency
    message = "INDEX|foo|\n"
    @indexer.perform(message)
    message = "INDEX|bar|foo\n"
    @indexer.perform(message)

    message = "REMOVE|foo|\n"
    assert_equal "FAIL\n", @indexer.perform(message)
  end

  def test_ok_query
    message = "INDEX|baz|\n"
    @indexer.perform(message)

    message = "QUERY|baz|\n"
    assert_equal "OK\n", @indexer.perform(message)
  end

  def test_faile_query
    message = "QUERY|baz|\n"
    assert_equal "FAIL\n", @indexer.perform(message)
  end
end