module Absinthe
  $:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'absinthe')))
  require 'distillery'

  def boot! boot_file, calling_context = nil, &block
    injector = Distillery.injector
    injector.register :app_root, File.expand_path(File.dirname(boot_file))
    injector.register :calling_context, calling_context
    injector.register :boot_proc, block
    injector.inject(:plugin).tap do |plugin|
      plugin.load :context
      plugin.boot!
    end
    injector.inject(:context)
  end

  extend self
end
