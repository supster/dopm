class Indexer
  COMMANDS = ['INDEX', 'REMOVE', 'QUERY']

  def initialize
    @data_store = {}
  end

  def perform(message)
    command, package, dependencies = message.chomp.split('|')

    return "ERROR\n" if !valid?(command, package)

    if !dependencies.nil?
      dependencies.split(',').each do |dependency|
        if !@data_store.has_key?(dependency)
          return "FAIL\n"
        end
      end
    else
      return "OK\n"
    end
  end

  def valid?(command, package)
    COMMANDS.include?(command) && !package.nil?
  end
end