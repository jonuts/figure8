module Figure8
  module Configurator
    def self.extended(base)
      base.class_eval do
        class << self; attr_reader :scope; end

        @scope ||= Figure8::Scope.new(base)
      end
    end

    def set(name, val=nil, &blk)
      if val.nil? && block_given?
        group(name, &blk)
      elsif val.nil?
        raise ArgumentError, "you must supply a value with your setting"
      else
        scope.find_or_create(:config, name).value = val
      end
    end

    def group(name, &blk)
      scope.find_or_create(:group, name).instance_eval(&blk)
    end

    def configs
      scope.configs
    end

    def groups
      scope.groups
    end

    def find_config(name)
      c = configs.find{ |e| e.name == name }
      c && !c.value.nil? ? c.value : c
    end
    alias :> :find_config

    def find_group(name)
      groups.find{ |e| e.name == name }
    end
    alias :[] :find_group
  end
end

