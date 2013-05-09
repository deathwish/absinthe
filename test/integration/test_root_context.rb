require 'test/unit'
require 'absinthe'

TOPLEVEL = self
class TestRootContext < Test::Unit::TestCase
  def setup
    Absinthe.boot! __FILE__
    @root_context = Absinthe.root_context
  end

  def teardown
    Absinthe.halt!
  end

  def test_root_context_is_cached
    rc2 = Absinthe.root_context
    assert_equal @root_context, rc2
  end

  def test_root_contexts_namespace_has_main
    assert_equal TOPLEVEL, @root_context[:namespace].main
  end
end
