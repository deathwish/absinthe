require 'test/unit'
require 'absinthe'

TOPLEVEL = self
class TestRootContext < Test::Unit::TestCase
  def test_contexts_namespace_has_main
    context = Absinthe.boot! __FILE__
    assert_equal TOPLEVEL, context[:namespace].main
  end

  def test_context_injects_params_for_run_blocks
    params = nil
    Absinthe.boot!(__FILE__) do
      const :a, 1
      const :b, 2
      run :a, :b, do |a, b|
        params = [a, b]
      end
    end
    assert_equal [1, 2], params
  end
end
