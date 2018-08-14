require 'test_helper'

class ZipCentralDirectoryTest < MiniTest::Test
  def teardown
    ::RubyZip.reset!
  end

  def test_read_from_stream
    ::File.open(TestZipFile::TEST_ZIP2.zip_name, 'rb') do |zipFile|
      cdir = ::RubyZip::CentralDirectory.read_from_stream(zipFile)

      assert_equal(TestZipFile::TEST_ZIP2.entry_names.size, cdir.size)
      assert(cdir.entries.sort.compare_enumerables(TestZipFile::TEST_ZIP2.entry_names.sort) do |cdirEntry, testEntryName|
        cdirEntry.name == testEntryName
      end)
      assert_equal(TestZipFile::TEST_ZIP2.comment, cdir.comment)
    end
  end

  def test_read_from_invalid_stream
    File.open('test/data/file2.txt', 'rb') do |zipFile|
      cdir = ::RubyZip::CentralDirectory.new
      cdir.read_from_stream(zipFile)
    end
    fail 'ZipError expected!'
  rescue ::RubyZip::Error
  end

  def test_read_from_truncated_zip_file
    fragment = ''
    File.open('test/data/testDirectory.bin', 'rb') { |f| fragment = f.read }
    fragment.slice!(12) # removed part of first cdir entry. eocd structure still complete
    fragment.extend(IOizeString)
    entry = ::RubyZip::CentralDirectory.new
    entry.read_from_stream(fragment)
    fail 'ZipError expected'
  rescue ::RubyZip::Error
  end

  def test_write_to_stream
    entries = [::RubyZip::Entry.new('file.zip', 'flimse', 'myComment', 'somethingExtra'),
               ::RubyZip::Entry.new('file.zip', 'secondEntryName'),
               ::RubyZip::Entry.new('file.zip', 'lastEntry.txt', 'Has a comment too')]
    cdir = ::RubyZip::CentralDirectory.new(entries, 'my zip comment')
    File.open('test/data/generated/cdirtest.bin', 'wb') { |f| cdir.write_to_stream(f) }
    cdirReadback = ::RubyZip::CentralDirectory.new
    File.open('test/data/generated/cdirtest.bin', 'rb') { |f| cdirReadback.read_from_stream(f) }

    assert_equal(cdir.entries.sort, cdirReadback.entries.sort)
  end

  def test_write64_to_stream
    ::RubyZip.write_zip64_support = true
    entries = [::RubyZip::Entry.new('file.zip', 'file1-little', 'comment1', '', 200, 101, ::RubyZip::Entry::STORED, 200),
               ::RubyZip::Entry.new('file.zip', 'file2-big', 'comment2', '', 18_000_000_000, 102, ::RubyZip::Entry::DEFLATED, 20_000_000_000),
               ::RubyZip::Entry.new('file.zip', 'file3-alsobig', 'comment3', '', 15_000_000_000, 103, ::RubyZip::Entry::DEFLATED, 21_000_000_000),
               ::RubyZip::Entry.new('file.zip', 'file4-little', 'comment4', '', 100, 104, ::RubyZip::Entry::DEFLATED, 121)]
    [0, 250, 18_000_000_300, 33_000_000_350].each_with_index do |offset, index|
      entries[index].local_header_offset = offset
    end
    cdir = ::RubyZip::CentralDirectory.new(entries, 'zip comment')
    File.open('test/data/generated/cdir64test.bin', 'wb') { |f| cdir.write_to_stream(f) }
    cdirReadback = ::RubyZip::CentralDirectory.new
    File.open('test/data/generated/cdir64test.bin', 'rb') { |f| cdirReadback.read_from_stream(f) }

    assert_equal(cdir.entries.sort, cdirReadback.entries.sort)
    assert_equal(::RubyZip::VERSION_NEEDED_TO_EXTRACT_ZIP64, cdirReadback.instance_variable_get(:@version_needed_for_extract))
  end

  def test_equality
    cdir1 = ::RubyZip::CentralDirectory.new([::RubyZip::Entry.new('file.zip', 'flimse', nil,
                                                          'somethingExtra'),
                                         ::RubyZip::Entry.new('file.zip', 'secondEntryName'),
                                         ::RubyZip::Entry.new('file.zip', 'lastEntry.txt')],
                                        'my zip comment')
    cdir2 = ::RubyZip::CentralDirectory.new([::RubyZip::Entry.new('file.zip', 'flimse', nil,
                                                          'somethingExtra'),
                                         ::RubyZip::Entry.new('file.zip', 'secondEntryName'),
                                         ::RubyZip::Entry.new('file.zip', 'lastEntry.txt')],
                                        'my zip comment')
    cdir3 = ::RubyZip::CentralDirectory.new([::RubyZip::Entry.new('file.zip', 'flimse', nil,
                                                          'somethingExtra'),
                                         ::RubyZip::Entry.new('file.zip', 'secondEntryName'),
                                         ::RubyZip::Entry.new('file.zip', 'lastEntry.txt')],
                                        'comment?')
    cdir4 = ::RubyZip::CentralDirectory.new([::RubyZip::Entry.new('file.zip', 'flimse', nil,
                                                          'somethingExtra'),
                                         ::RubyZip::Entry.new('file.zip', 'lastEntry.txt')],
                                        'comment?')
    assert_equal(cdir1, cdir1)
    assert_equal(cdir1, cdir2)

    assert(cdir1 != cdir3)
    assert(cdir2 != cdir3)
    assert(cdir2 != cdir3)
    assert(cdir3 != cdir4)

    assert(cdir3 != 'hello')
  end
end
