module TestUnitExt
  # Same as the stock equivalent, with the addition of the message being batched
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
  
  def catch_error(type=Exception)
    begin
      yield
    rescue => error
    end
    assert_kind_of(type, error)
    return error
  end
  
  chain_call_variation_targets =  { :expects  => :mock,
                                    :stubs    => :stub  }

  chain_call_variation_targets.each do |method, build_receiver|
    define_method("#{method}_chain") do |obj, chain|
      chain = chain.split('.')
      raise ArgumentError, "empty call chain" if chain.empty?

      expectation, receiver = nil, obj
      loop do
        expectation = receiver.send(method, chain.shift.to_sym)
        break if chain.empty?
        expectation.returns(receiver = send(build_receiver))
      end
      expectation
    end
  end

  def expects_chain_never(obj, chain)
    chain = chain.split('.')
    raise ArgumentError, "empty call chain" if chain.empty?
  
    obj.expects(chain.first.to_sym).never
  end
  
  if defined?(ActiveRecord)
    # Details in the {introduction article}[http://roman.flucti.com/painless-record-creation-with-activerecord].
    def insert!(model, attributes={}, options={})
      attributes          = attributes.stringify_keys
      trigger_validation  = options.fetch(:trigger_validation, false)
      inhibit_callbacks   = options.fetch(:inhibit_callbacks, !trigger_validation)
      begin
        record = model.new { |record| record.send(:attributes=, attributes, false) }
        if inhibit_callbacks
          def record.callback(*args)
          end
        end
        if trigger_validation
          record.valid?
        end
        record.save(false)
      rescue ActiveRecord::StatementInvalid
        if $!.message =~ /Column '(.+?)' cannot be null/
          unless attributes.key?($1)
            attributes[$1] = record.column_for_attribute($1).number? ? 0 : "-"
            retry
          end
        end
        raise
      end
      return record
    end
    
    # Extracted from activerecord/test/cases/helper.rb
    ActiveRecord::Base.connection.class.class_eval do
      IGNORED_SQL = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SHOW FIELDS/]

      def execute_with_query_record(sql, name = nil, &block)
        $queries_executed ||= []
        $queries_executed << sql unless IGNORED_SQL.any? { |r| sql =~ r }
        execute_without_query_record(sql, name, &block)
      end
    
      alias_method_chain :execute, :query_record
    end
  
    # Extracted from activerecord/lib/active_record/test_case.rb
    def assert_queries(num = 1)
      $queries_executed = []
      yield
    ensure
      assert_equal num, $queries_executed.size, "#{$queries_executed.size} instead of #{num} queries were executed.#{$queries_executed.size == 0 ? '' : "\nQueries:\n#{$queries_executed.join("\n")}"}"
    end
  end
end

Object.class_eval do
  alias ieval :instance_eval
end

if defined? Mocha::Configuration
  Mocha::Configuration.prevent :stubbing_non_existent_method
  Mocha::Configuration.warn_when :stubbing_method_unnecessarily
end
