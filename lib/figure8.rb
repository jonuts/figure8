dir = File.dirname(__FILE__)
$:.unshift(dir) unless $:.include?(dir)

require 'ext'
require 'figure8/collection_mixin'
require 'figure8/configurator'
require 'figure8/config'
require 'figure8/scope'

# FIGURE8
# =======
# encapsulate your configuration details in a succinct and pretty way
#
# Basic Usage
# ===========
# To create the encapsulating class, there are a few options:
#
# f8 :Config do
#   set :parameter, "value"
# end
#
# You can now access the config by calling
#   Config>( :foo )
# 
# You can also set groups
#   f8 :Config do
#     group :group do
#       set :param, "value"
#     end
#   end
#
# The group params can be accessed by calling
#   Config[:group]
#
# Group configs will be separate from each other
#   f8 :Config do
#     set :param, "foo"
#     group :group do
#       set :param, "bar"
#     end
#   end
#
#   Config> :param #=> "foo"
#   Config[:group]> :param #=> "bar"
# 
#
# The config class can also be created manually:
#   class Klass
#     extend Figure8::Configurator
#   end
#
#   Klass.set :param, "value"
#   Klass.group(:grouping){ set :param, "value" }
#
module Figure8
  class NotConstantizableError < ArgumentError ; end

  module F8
    def f8(obj, &config)
      raise ArgumentError, "`obj' must be a String or Symbol" unless obj.is_a?(String) || obj.is_a?(Symbol)
      raise NotConstantizableError, "`#{obj}' is not able to be constantized. perhaps you meant `#{obj.to_s.capitalize}'?" unless
        obj.to_s.capitalized?

      obj = Object.const_get(obj)
    rescue NameError
      obj = Object.const_set(obj, Class.new)
    ensure
      if obj.respond_to?(:class_eval) && block_given?
        obj.extend Figure8::Configurator
        obj.class_eval(&config)
      end
    end
  end
end

Object.send :include, Figure8::F8
