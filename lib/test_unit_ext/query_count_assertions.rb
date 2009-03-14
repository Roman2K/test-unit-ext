module TestUnitExt::QueryCountAssertions
  # Extracted from activerecord/test/cases/helper.rb
  ActiveRecord::Base.connection.class.class_eval do
    unless method_defined? :execute_with_query_record
      unless const_defined? :IGNORED_SQL
        IGNORED_SQL = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SHOW FIELDS/]
      end
      def execute_with_query_record(sql, name = nil, &block)
        $queries_executed ||= []
        $queries_executed << sql unless IGNORED_SQL.any? { |r| sql =~ r }
        execute_without_query_record(sql, name, &block)
      end
      alias_method_chain :execute, :query_record
    end
  end

  # Extracted from activerecord/lib/active_record/test_case.rb
  def assert_queries(num=1)
    $queries_executed = []
    yield
  ensure
    assert_equal num, $queries_executed.size, "#{$queries_executed.size} instead of #{num} queries were executed.#{$queries_executed.size == 0 ? '' : "\nQueries:\n#{$queries_executed.join("\n")}"}"
  end
end
