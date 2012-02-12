# TestUnitExt

Helper methods for `Test::Unit::TestCase`. See the documentation of each method for a description and usage examples.

## Usage

In `test_helper.rb` or any particular test file:

    require 'test_unit_ext'
    
    Test::Unit::TestCase.class_eval do
      include TestUnitExt
    end

If you are using [Mocha](http://mocha.rubyforge.org/), be sure to `require 'mocha'` first.

## Credits

* Roman Le Négrate
* [David Heinemeier Hansson](http://loudthinking.com) - `#assert_queries`
