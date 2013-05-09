module Absinthe
  class NotInitialized < Exception; end
  $:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'absinthe')))
  require 'distillery'

  def boot! boot_file, calling_context = nil, &block
    injector = Distillery.injector
    injector.register :app_root, File.expand_path(File.dirname(boot_file))
    injector.register :calling_context, calling_context
    injector.register :boot_proc, block
    injector.inject(:plugin).load :context
    @root_context = injector.inject :context
    @root_context.boot!
  end

  def halt!
    @root_context = nil
  end

  def root_context
    raise NotInitialized, "You must call Absinthe.boot! before retrieving the root context!" if @root_context.nil?
    @root_context
  end

  extend self
end
