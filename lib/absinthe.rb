module Absinthe
  $:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'absinthe')))
  require 'dsl'
  require 'distillery'
  require 'distillery/context'

  extend Dsl

  def self.root_context
    @root_context ||= Distillery::Context.new Distillery.injector
  end
end
