# encoding: utf-8

require 'test_helper'

class ZipUnicodeFileNamesAndComments < MiniTest::Test
  FILENAME = File.join(File.dirname(__FILE__), 'test1.zip')

  def test_unicode_file_name
    file_entrys = ['текстовыйфайл.txt', 'Résumé.txt', '슬레이어스휘.txt']
    directory_entrys = ['папка/текстовыйфайл.txt', 'Résumé/Résumé.txt', '슬레이어스휘/슬레이어스휘.txt']
    stream = ::RubyZip::OutputStream.open(FILENAME) do |io|
      file_entrys.each do |filename|
        io.put_next_entry(filename)
        io.write(filename)
      end
      directory_entrys.each do |filepath|
        io.put_next_entry(filepath)
        io.write(filepath)
      end
    end
    assert(!stream.nil?)
    ::RubyZip::InputStream.open(FILENAME) do |io|
      file_entrys.each do |filename|
        entry = io.get_next_entry
        entry_name = entry.name
        entry_name = entry_name.force_encoding('UTF-8')
        assert(filename == entry_name)
      end
      directory_entrys.each do |filepath|
        entry = io.get_next_entry
        entry_name = entry.name
        entry_name = entry_name.force_encoding('UTF-8')
        assert(filepath == entry_name)
      end
    end
    ::File.unlink(FILENAME)
  end

  def test_unicode_comment
    str = '渠道升级'
    ::RubyZip::File.open(FILENAME, RubyZip::File::CREATE) do |z|
      z.comment = str
    end

    ::RubyZip::File.open(FILENAME) do |z|
      assert(z.comment.force_encoding('UTF-8') == str)
    end
    ::File.unlink(FILENAME)
  end
end
