module TestUnitExt
  def assert_raise(exception_class, message=nil)
    begin
      yield
    rescue => error
    end

    exc_expected_msg = message ? ": #{message.inspect}" : ''
    assertion_message = "expected to raise <#{exception_class}#{exc_expected_msg}> but raised #{error.inspect}"
    assert_block(assertion_message) do
      exception_class === error && (message || //) === (error.message || '')
    end

    error
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
    def insert!(model, attributes={})
      attributes = attributes.stringify_keys
      begin
        record = model.new { |record| record.send(:attributes=, attributes, false) }
        def record.callback(*args)
          # inhibit all callbacks
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
