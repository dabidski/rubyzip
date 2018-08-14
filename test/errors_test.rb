# encoding: utf-8
require 'test_helper'

class ErrorsTest < MiniTest::Test
  def test_rescue_legacy_zip_error
    raise ::RubyZip::Error
  rescue ::RubyZip::ZipError
  end

  def test_rescue_legacy_zip_entry_exists_error
    raise ::RubyZip::EntryExistsError
  rescue ::RubyZip::ZipEntryExistsError
  end

  def test_rescue_legacy_zip_destination_file_exists_error
    raise ::RubyZip::DestinationFileExistsError
  rescue ::RubyZip::ZipDestinationFileExistsError
  end

  def test_rescue_legacy_zip_compression_method_error
    raise ::RubyZip::CompressionMethodError
  rescue ::RubyZip::ZipCompressionMethodError
  end

  def test_rescue_legacy_zip_entry_name_error
    raise ::RubyZip::EntryNameError
  rescue ::RubyZip::ZipEntryNameError
  end

  def test_rescue_legacy_zip_internal_error
    raise ::RubyZip::InternalError
  rescue ::RubyZip::ZipInternalError
  end
end
