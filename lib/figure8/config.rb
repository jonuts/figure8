module Figure8
  class Config
    def initialize(opts={})
      @name = opts.delete(:name)
      @value = opts.delete(:value)
    end

    attr_accessor :name, :value
  end
end

