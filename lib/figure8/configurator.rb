module Figure8
  module Configurator

    def self.extended(base)
      base.const_set("Config", Class.new(Figure8::Config){
        include CollectionMixin

        find_by :name
      }) unless base.constants.include?("Config")

      base.const_set("Group", Class.new(Figure8::Group){
        include CollectionMixin

        find_by :name
        @scope = base
      }) unless base.constants.include?("Group")
    end

    def set(name, val=nil, &blk)
      if val.nil? && block_given?
        group(name, &blk)
      elsif val.nil?
        raise ArgumentError, "you must supply a value with your setting"
      else
        find_or_create(const_get("Config"), name).value = val
      end
    end

    def group(name, &blk)
      find_or_create(const_get("Group"), name).instance_eval(&blk)
    end

    def [](name)
      return self::Group[name] if self::Group[name]

      find_config(name)
    end

    def find_config(name)
      c = self::Config[name]
      c.value if c && !c.value.nil? 
    end

    def find_group(name)
      self::Group[name]
    end

    def find_or_create(klass, name)
      klass[name] || klass.new(:name => name)
    end

  end
end

