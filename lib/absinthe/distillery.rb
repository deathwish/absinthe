module Absinthe
  module Plugins; end

  class Exception < ::Exception; end

  module Distillery
    require 'distillery/injector'
    require 'distillery/root_namespace'
    require 'distillery/source_loader'
    require 'distillery/plugin'

    def self.injector
      Injector.new.tap do |injector|
        injector.register :main_object, @main_object
        injector.register :namespace, RootNamespace, :context, :main_object
        injector.register :source_loader, SourceLoader, :app_root, :namespace
        injector.register :plugin, Plugin, :context, :source_loader
      end
    end

    def self.configure main_object
      @main_object = main_object
    end
  end
end
# Always.
Absinthe::Distillery.configure self
