module Figure8
  class Config
    include CollectionMixin

    find_by :name

    def initialize(opts={})
      @name  = opts.delete(:name)
      @value = opts.delete(:value)
      super
    end

    attr_accessor :name, :value
  end

  class Group
    include CollectionMixin

    find_by :name

    def initialize(opts={})
      @name = opts.delete(:name)
      @configs = []
      super
    end

    attr_reader :configs, :name

    def find_config(name, chain=false)
      c = configs.find{ |c| c.name == name }
      if chain
        c
      else
        c ? c.value : c
      end
    end
    alias :> :find_config

    def find_or_create_config(name)
      find_config(name, true) || configs.push(Figure8::Config.new(:name => name)).last
    end

    def set(name, val)
      find_or_create_config(name).value = val
    end
  end

end

