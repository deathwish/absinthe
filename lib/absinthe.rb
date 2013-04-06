module Absinthe
  $:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'absinthe')))
  require 'dsl'
  require 'distillery'

  extend Dsl
end
