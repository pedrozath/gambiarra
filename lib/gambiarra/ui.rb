require 'thor'
require 'gambiarra'

require File.expand_path('../ui/base_view', __FILE__)
views = Dir[File.expand_path('../ui/views/*', __FILE__)].map { |view| require(view) }
