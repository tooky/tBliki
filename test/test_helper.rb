module SimpleTest
  class Context
    attr_reader :__name
    def initialize name
      @__name = name
    end

    def __tests
      @__tests ||= {}
    end

    def check name, &block
      __tests[name] = block
    end

    def report
      puts __name
      __tests.each_pair do |name, test|
        result = test.call ? 'PASS' : 'FAIL' 
        puts "\t#{result} : #{name}"
      end
    end

    def should_equal(expected, actual)
      expected == actual
    end
  end
end
class Object
  def context name, &block
    the_context = SimpleTest::Context.new name
    the_context.instance_eval &block
    the_context.report
  end
end
if ENV['META_TEST']
  context 'simple tests' do
    check 'true is true' do
      should_equal true, true
    end

    check 'true is not false' do
      !should_equal true, false
    end
  end
end
