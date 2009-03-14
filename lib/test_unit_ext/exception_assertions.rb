module TestUnitExt::ExceptionAssertions
  # Same as the stock equivalent, with the addition of the message being matched
  # against the exception raised within the block.
  #
  # Messages can be matched in a strict manner:
  #
  #   assert_raise(RuntimeError, "the message") do
  #     raise "the  message"
  #   end
  #
  # Or loosely:
  #
  #   assert_raise(ArgumentError, /wrong number of arguments/) do
  #     "hello".gsub(/e/)
  #   end
  #
  def assert_raise(exception_class, message=nil)
    begin
      yield
    rescue => error
    end
    exc_expected_msg = message ? ": #{message.inspect}" : ''
    assertion_message = "expected to raise <#{exception_class}#{exc_expected_msg}> but raised #{error.inspect}"
    assertion_message << "\n#{(error.backtrace || []).join("\n").gsub(/^/, "\t")}" if error
    assert_block(assertion_message) do
      exception_class === error && (message || //) === (error.message || '')
    end
    return error
  end
  
  # Catch any exception of a given type that would be raised within the block.
  #
  # For example:
  #
  #   err = catch_error { puts "success" }  # => nil
  #   err = catch_error { raise "error" }   # => #<RuntimeError: error>
  #
  def catch_error(type=Exception)
    begin
      yield
    rescue => error
    end
    assert_kind_of(type, error)
    return error
  end
end
