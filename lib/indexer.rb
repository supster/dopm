class Indexer
  COMMANDS = ['INDEX', 'REMOVE', 'QUERY']
  OK = "OK\n"
  FAIL = "FAIL\n"
  ERROR = "ERROR\n"

  def initialize
    @data_store = {}
  end

  def perform(message)
    command, package, dependencies = message.chomp.split('|')

    return ERROR if !valid?(command, package)

    if command == 'INDEX'
      status = index(package, dependencies)
    elsif command == 'REMOVE'
      status = remove(package)
    elsif command == 'QUERY'
      status = query(package)
    end
    status
  end

  def valid?(command, package)
    COMMANDS.include?(command) && !package.nil?
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