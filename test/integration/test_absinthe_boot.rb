require 'test/unit'
require 'absinthe'

class TestAbsintheBoot < Test::Unit::TestCase
  def teardown
    Absinthe.halt!
  end

  def test_registers_constants_on_the_root_context
    Absinthe.boot!(__FILE__) { |ctx|
      ctx.const :foo, :bar
    }
    assert_equal :bar, Absinthe::Distillery.root_context[:foo]
  end

  def test_calls_the_block_in_the_given_scope
    calling_context = Object.new
    Absinthe.boot!(__FILE__, calling_context) do |ctx|
      @scope_var = 'set_on_scope'
    end
    assert_equal 'set_on_scope', calling_context.instance_variable_get(:@scope_var)
  end
end
