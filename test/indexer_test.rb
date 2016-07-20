require 'minitest/autorun'
require_relative '../lib/indexer'

class IndexerTest < Minitest::Test
  def setup
    File.stub :read, '{}' do
      @indexer = Indexer.new
    end
  end

  def test_error_wrong_command
    message = "FOO|error|\n"
    assert_equal Indexer::ERROR, @indexer.perform(message)

    message = "QUER|a|b"
    assert_equal Indexer::ERROR, @indexer.perform(message)
  end

  def test_error_bad_pattern
    message = "INDEX\n"
    assert_equal Indexer::ERROR, @indexer.perform(message)

    message = "REMOVE|\n"
    assert_equal Indexer::ERROR, @indexer.perform(message)

    message = "I|a|b|\n"
    assert_equal Indexer::ERROR, @indexer.perform(message)
  end

  def test_error_nil_and_blank
    message = nil
    assert_equal Indexer::ERROR, @indexer.perform(message)

    message = ""
    assert_equal Indexer::ERROR, @indexer.perform(message)
  end

  def test_ok_index_new
    message = "INDEX|ceylon|\n"
    assert_equal Indexer::OK, @indexer.perform(message)
  end

  def test_ok_index_package_exist
    message = "INDEX|ceylon|\n"
    @indexer.perform(message)

    assert_equal Indexer::OK, @indexer.perform(message)
  end

  def test_ok_index_dependencies_exist
    message = "INDEX|ceylon|\n"
    @indexer.perform(message)

    message = "INDEX|bar|ceylon\n"
    assert_equal Indexer::OK, @indexer.perform(message)
  end

  def test_fail_index_dependencies_not_exist
    message = "INDEX|ceylon|gmp\n"
    assert_equal Indexer::FAIL, @indexer.perform(message)
  end

  def test_ok_remove
    message = "INDEX|foo|\n"
    @indexer.perform(message)

    message = "REMOVE|foo|\n"
    assert_equal Indexer::OK, @indexer.perform(message)
  end

  def test_ok_remove_not_exist
    message = "REMOVE|foo|\n"

    assert_equal Indexer::OK, @indexer.perform(message)
  end

  def test_fail_remove_dependency
    message = "INDEX|foo|\n"
    @indexer.perform(message)
    message = "INDEX|bar|foo\n"
    @indexer.perform(message)

    message = "REMOVE|foo|\n"
    assert_equal Indexer::FAIL, @indexer.perform(message)
  end

  def test_ok_query
    message = "INDEX|baz|\n"
    @indexer.perform(message)

    message = "QUERY|baz|\n"
    assert_equal Indexer::OK, @indexer.perform(message)
  end

  def test_fail_query
    message = "QUERY|baz|\n"
    assert_equal Indexer::FAIL, @indexer.perform(message)
  end

  def test_load_no_data_from_file
    assert_equal Hash.new, @indexer.load_data_from_file
  end

  def test_load_some_data_from_file
    data = '{"foo":"","bar":["foo"]}'
    File.stub :read, data do
      assert_equal JSON.parse(data), @indexer.load_data_from_file
    end
  end

  def test_save_data_to_file
    File.stub :write, '{foo: ""}' do
      assert @indexer.save_data_to_file
    end
  end
end