#!/usr/bin/env ruby
require './lib/server'

Server.new.start ARGV[0] || 8080