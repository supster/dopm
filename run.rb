#!/usr/bin/env ruby
require './lib/server'

Server.new(Indexer.new).start ARGV[0] || 8080