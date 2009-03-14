module TestUnitExt
  autoload :ExceptionAssertions,  'test_unit_ext/exception_assertions'
  autoload :OppositeExpectation,  'test_unit_ext/opposite_expectation'
  autoload :EasyRecordInsertion,  'test_unit_ext/easy_record_insertion'
  autoload :QueryCountAssertions, 'test_unit_ext/query_count_assertions'
  
  include ExceptionAssertions
  include OppositeExpectation
  if defined? ActiveRecord
    include EasyRecordInsertion
    include QueryCountAssertions
  end
end

Object.class_eval do
  alias ieval :instance_eval
end

if defined? Mocha::Configuration
  Mocha::Configuration.prevent :stubbing_non_existent_method
  Mocha::Configuration.warn_when :stubbing_method_unnecessarily
end
