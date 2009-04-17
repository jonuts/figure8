module Figure8
  module Configurator

    # NOTE: i suck
    def self.extended(base)
      base.class_eval do
        class << self; attr_reader :scope; end

        @scope = base
      end

      Object.class_eval("class #{base.name}::Config; end; class #{base.name}::Group; end")

      base::Config.class_eval do
        include CollectionMixin

        find_by :name

        def initialize(opts={})
          @name = opts.delete(:name)
          @value = opts.delete(:value)
          super
        end

        attr_accessor :name, :value
      end

      base::Group.class_eval do
        include CollectionMixin

        class << self; attr_reader :scope; end
        
        @scope = base

        find_by :name

        def initialize(opts={})
          @name = opts.delete(:name)
          @configs = []
          super
        end

        attr_reader :name, :configs

        def find_config(name, chain=false)
          c = configs.find{ |c| c.name == name }

          return c if chain

          c ? c.value : c
        end
        alias :[] :find_config

        def find_or_create_config(name)
          find_config(name, true) || configs.push(self.class.scope::Config.new(:name => name)).last
        end

        def set(name, val)
          find_or_create_config(name).value = val
        end

      end
    end

    def set(name, val=nil, &blk)
      if val.nil? && block_given?
        group(name, &blk)
      elsif val.nil?
        raise ArgumentError, "you must supply a value with your setting"
      else
        find_or_create(scope::Config, name).value = val
      end
    end

    def group(name, &blk)
      find_or_create(scope::Group, name).instance_eval(&blk)
    end

    def [](name)
      return scope::Group[name] if scope::Group[name]

      find_config(name)
    end

    def find_config(name)
      c = scope::Config[name]
      c.value if c && !c.value.nil? 
    end

    def find_group(name)
      scope::Group[name]
    end

    def find_or_create(klass, name)
      klass[name] || klass.new(:name => name)
    end
  end
end

