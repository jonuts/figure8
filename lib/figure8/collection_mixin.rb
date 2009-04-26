module Figure8
  module CollectionMixin
    def self.included(base)
      base.class_eval do
        extend Enumerable
        extend ClassMethods

        class << self 
          attr_reader :finder, :collection

          def find_by(attribute)
            @finder = attribute
          end
        end

        @collection ||= []
      end
    end

    module ClassMethods
      def [](thing)
        find{|e| thing == e.send(self.finder)}
      end

      def each
        @collection.each{|i| yield i}
      end
    end

    def initialize(*args)
      super
      add_self_to_collection
    end

    private

    def add_self_to_collection
      self.class.collection << self unless self.class[send(self.class.finder)]
    end
  end
end

