require 'test_helper'

class TestPluginInjector < Test::Unit::TestCase
  class Foo
    attr_reader :msg

    def initialize msg
      @msg = msg
    end
  end

  def test_injector_is_available_in_run_blocks
    Absinthe.boot!(__FILE__, self) do
      plugin! :plugin_injector
      run do
        assert PluginInjector.class
      end
    end
  end

  def test_injected_plugins_are_proxied_on_the_namespace
    context = Absinthe.boot!(__FILE__) do
      register :baxter, Foo, 'hi!'
      plugin! :plugin_injector
    end

    msg = context[:namespace].root::Context[:baxter].msg
    assert_equal 'hi!', msg
  end
end
