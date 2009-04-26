module Figure8
  class Group
    class << self; attr_reader :scope; end

    def initialize(opts={})
      @name = opts.delete(:name)
      @configs = []
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

