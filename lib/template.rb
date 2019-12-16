# frozen_string_literal: true

require 'erubis'

# Extend Erubis::Eruby class to provide YAML subtemplates.
class Template < Erubis::Eruby
  # Function for rendering sub-template. ugly as hell.
  #
  # * `indent` is number of spaces to indent every line except first one.
  # * `bufvar` needs to be a unique string if nesting templates.
  # * `binding` is just `binding` from parent template if you don't need something extra.
  def template(filename, indent, bufvar, binding)
    Erubis::Eruby.new(file(filename, indent), bufvar: bufvar).result(binding)
  end

  # Function for including a static file in template.
  #
  # `indent` is number of spaces to indent every line except first one.
  def file(filename, indent)
    line_num = 0
    File.readlines(filename).each do |line|
      line_num += 1
      line.prepend(' ' * indent) unless line.empty? || line_num == 1
    end.join.chomp
  end
end
