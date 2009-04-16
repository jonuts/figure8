module Figure8
  module CollectionMixin
    def self.included(base)
      base.class_eval do
        extend ClassMethods

        class << self 
          attr_accessor :all
          attr_reader :finder

          def find_by(attribute)
            @finder = attribute
          end
        end
      end
    end

    module ClassMethods
      def [](thing)
        find(thing)
      end

      def find(thing)
        Array(all).find{ |e| e.send(self.finder) == thing }
      end
    end

    def initialize(*args)
      add_self_to_collection
    end

    private

    def add_self_to_collection
      self.class.all ||= []
      self.class.all << self unless self.class[self]
    end
  end
end
