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

  class Group < Config
    class << self; attr_accessor :configs; end

    def initialize(*opts)
      self.class.configs = []
      super
    end
  end

end

