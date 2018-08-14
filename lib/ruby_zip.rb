require 'delegate'
require 'singleton'
require 'tempfile'
require 'tmpdir'
require 'fileutils'
require 'stringio'
require 'zlib'
require 'ruby_zip/dos_time'
require 'ruby_zip/ioextras'
require 'rbconfig'
require 'ruby_zip/entry'
require 'ruby_zip/extra_field'
require 'ruby_zip/entry_set'
require 'ruby_zip/central_directory'
require 'ruby_zip/file'
require 'ruby_zip/input_stream'
require 'ruby_zip/output_stream'
require 'ruby_zip/decompressor'
require 'ruby_zip/compressor'
require 'ruby_zip/null_decompressor'
require 'ruby_zip/null_compressor'
require 'ruby_zip/null_input_stream'
require 'ruby_zip/pass_thru_compressor'
require 'ruby_zip/pass_thru_decompressor'
require 'ruby_zip/crypto/encryption'
require 'ruby_zip/crypto/null_encryption'
require 'ruby_zip/crypto/traditional_encryption'
require 'ruby_zip/inflater'
require 'ruby_zip/deflater'
require 'ruby_zip/streamable_stream'
require 'ruby_zip/streamable_directory'
require 'ruby_zip/constants'
require 'ruby_zip/errors'

module RubyZip
  extend self
  attr_accessor :unicode_names, :on_exists_proc, :continue_on_exists_proc, :sort_entries, :default_compression, :write_zip64_support, :warn_invalid_date, :case_insensitive_match

  def reset!
    @_ran_once = false
    @unicode_names = false
    @on_exists_proc = false
    @continue_on_exists_proc = false
    @sort_entries = false
    @default_compression = ::Zlib::DEFAULT_COMPRESSION
    @write_zip64_support = false
    @warn_invalid_date = true
    @case_insensitive_match = false
  end

  def setup
    yield self unless @_ran_once
    @_ran_once = true
  end

  reset!
end

# Copyright (C) 2002, 2003 Thomas Sondergaard
# rubyzip is free software; you can redistribute it and/or
# modify it under the terms of the ruby license.
