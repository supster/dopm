class Indexer
  COMMANDS = ['INDEX', 'REMOVE', 'QUERY']
  OK = "OK\n"
  FAIL = "FAIL\n"
  ERROR = "ERROR\n"

  def initialize
    @data_store = {}
  end

  def perform(message)
    return ERROR if message_error?(message)

    command = message.chomp.split('|')

    return ERROR if command_error?(command)

    if command[0] == 'INDEX'
      status = index(command[1], command[2])
    elsif command[0] == 'REMOVE'
      status = remove(command[1])
    elsif command[0] == 'QUERY'
      status = query(command[1])
    else
      status = ERROR
    end
    status
  end

  def message_error?(message)
    message.nil? || message.count('|') != 2
  end

  def command_error?(command)
    !COMMANDS.include?(command[0]) || command[1].nil?
  end

  def index(package, dependencies)
    if !dependencies.nil?
      dependencies = dependencies.split(',')
      return FAIL unless packages_exist?(dependencies)
    end

    @data_store[package] = dependencies
    OK
  end

  def packages_exist?(packages)
    packages.each do |package|
      return false unless @data_store.has_key?(package)
    end
    true
  end

  def remove(package)
    @data_store.values.compact.each do |dependencies|
      return FAIL if dependencies.include?(package)
    end

    @data_store.delete(package)
    OK
  end

  def query(package)
    if @data_store.has_key?(package)
      OK
    else
      FAIL
    end
  end
end