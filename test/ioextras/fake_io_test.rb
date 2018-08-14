require 'test_helper'
require 'ruby_zip/ioextras'

class FakeIOTest < MiniTest::Test
  class FakeIOUsingClass
    include ::RubyZip::IOExtras::FakeIO
  end

  def test_kind_of?
    obj = FakeIOUsingClass.new

    assert(obj.kind_of?(Object))
    assert(obj.kind_of?(FakeIOUsingClass))
    assert(obj.kind_of?(IO))
    assert(!obj.kind_of?(Integer))
    assert(!obj.kind_of?(String))
  end
end
