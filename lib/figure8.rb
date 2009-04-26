dir = File.dirname(__FILE__)
$:.unshift(dir) unless $:.include?(dir)

require 'ext'
require 'figure8/collection_mixin'
require 'figure8/group'
require 'figure8/config'
require 'figure8/configurator'

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
    def f8(klass, &config)
      raise ArgumentError, "`klass' must be a String or Symbol" unless klass.is_a?(String) || klass.is_a?(Symbol)
      raise NotConstantizableError, "`#{klass}' is not able to be constantized. perhaps you meant `#{klass.to_s.capitalize}'?" unless
        klass.to_s.capitalized?

      klass = Object.const_get(klass)
    rescue NameError
      klass = Object.const_set(klass, Class.new)
    ensure
      if klass.respond_to?(:class_eval) && block_given?
        klass.extend Figure8::Configurator
        klass.class_eval(&config)
      end
    end
    alias :configurate :f8

  end
end

Object.send :include, Figure8::F8
