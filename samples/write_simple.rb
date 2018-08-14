#!/usr/bin/env ruby

$: << '../lib'

require 'ruby_zip'

include RubyZip

OutputStream.open('simple.zip') do |zos|
  zos.put_next_entry 'entry.txt'
  zos.puts 'Hello world'
end
