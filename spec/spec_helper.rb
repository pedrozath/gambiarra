# frozen_string_literal: true

require 'simplecov'
require 'pry'

SimpleCov.start

$LOAD_PATH.unshift(File.expand_path('../../', __FILE__))

require 'bundler'
Bundler.require(:test)

require 'gambiarra'
require 'spec/dummy_app/lib/dummy_app'

RSpec.configure
