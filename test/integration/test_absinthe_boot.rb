require 'test_helper'

class TestAbsintheBoot < Test::Unit::TestCase
  def test_registers_constants_on_the_returned_context
    context = Absinthe.boot!(__FILE__) {
      const :foo, :bar
    }
    assert_equal :bar, context[:foo]
  end

  def test_calls_run_blocks_in_the_given_scope
    calling_context = Object.new
    Absinthe.boot!(__FILE__, calling_context) do
      run do
        @scope_var = 'set_on_scope'
      end
    end
    assert_equal 'set_on_scope', calling_context.instance_variable_get(:@scope_var)
  end
end
