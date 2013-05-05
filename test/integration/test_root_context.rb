require 'test/unit'
require 'absinthe'

TOPLEVEL = self
class TestRootContext < Test::Unit::TestCase
  def setup
    @root_context = Absinthe::Distillery.root_context
  end

  def test_root_context_is_cached
    rc2 = Absinthe::Distillery.root_context
    assert_equal @root_context, rc2
  end

  def test_root_contexts_namespace_has_main
    assert_equal TOPLEVEL, @root_context[:namespace].main
  end
end
