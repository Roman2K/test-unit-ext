# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{test-unit-ext}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roman Le N\303\251grate"]
  s.date = %q{2009-03-14}
  s.description = %q{Helper methods for Test::Unit::TestCase}
  s.email = %q{roman.lenegrate@gmail.com}
  s.extra_rdoc_files = ["lib/test_unit_ext/easy_record_insertion.rb", "lib/test_unit_ext/exception_assertions.rb", "lib/test_unit_ext/opposite_expectation.rb", "lib/test_unit_ext/query_count_assertions.rb", "lib/test_unit_ext.rb", "LICENSES", "README.mdown"]
  s.files = ["lib/test_unit_ext/easy_record_insertion.rb", "lib/test_unit_ext/exception_assertions.rb", "lib/test_unit_ext/opposite_expectation.rb", "lib/test_unit_ext/query_count_assertions.rb", "lib/test_unit_ext.rb", "LICENSES", "Manifest", "Rakefile", "README.mdown", "test-unit-ext.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{https://github.com/Roman2K/test-unit-ext}
  s.rdoc_options = ["--main", "README.mdown", "--inline-source", "--line-numbers", "--charset", "UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{test-unit-ext}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Helper methods for Test::Unit::TestCase}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
