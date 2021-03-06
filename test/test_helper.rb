module SimpleTest
  class Context
    def initialize name
      @__vars = {}
      @__vars[:name] = name
    end

    def __name
      @__vars[:name]
    end

    def __tests
      @__vars[:tests] ||= {}
    end

    def __setup
      @__vars[:setup]
    end

    def check name, &block
      __tests[name] = block
    end

    def setup &block
      @__vars[:setup] = block
    end

    def report
      puts __name
      __tests.each_pair do |name, test|
        test_variables.each {|var| instance_variable_set(var, nil)}
        __setup.call if __setup
        result = test.call ? 'PASS' : 'FAIL' 
        puts "\t#{result} : #{name}"
      end
    end

    def test_variables
      instance_variables - ['@__vars']
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

  context 'instance variables' do
    check 'can be evaluated' do
      @var = 1234
      should_equal 1234, @var
    end
    check 'do not affect other tests' do
      should_equal @var, nil
    end
  end

  context 'tests with setup' do
    setup do
      @var = 'hello'
    end

    check 'instance variables set in setup available in tests' do
      should_equal 'hello', @var
    end
  end
end
