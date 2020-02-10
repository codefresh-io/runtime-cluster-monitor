# frozen_string_literal: true

$LOAD_PATH.unshift File.join(Dir.pwd, 'lib')

require 'vars'
require 'helm4rake'

Helm4Rake.new(CHARTS, CONTEXTS, NAMESPACE)
require 'tasks'
