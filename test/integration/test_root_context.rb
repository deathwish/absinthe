require 'test/unit'
require 'absinthe'

TOPLEVEL = self
class TestRootContext < Test::Unit::TestCase
  def setup
    @context = Absinthe.boot! __FILE__
  end

  def test_contexts_namespace_has_main
    assert_equal TOPLEVEL, @context[:namespace].main
  end
end
