module Figure8
  class Scope
    include CollectionMixin

    find_by :object_id

    def initialize(*args)
      @configs = []
      @groups  = []
      super
    end

    attr_reader :configs, :groups

    # Find a group or config
    #
    # ==== Parameters
    # which<Symbol|String>:: :group or :config
    def find(which, name)
      send(which.to_s.pluralize).find{ |c| c.name == name }
    end

    def find_or_create(which, name)
      case which
      when :group
        find(:group, name) || groups.push(Group.new(:name => name)).last
      when :config
        find(:config, name) || configs.push(Config.new(:name => name)).last
      end
      #find(which, name) || send(which.to_s.pluralize).push(constantize(which).new(:name => name)).last
    end

  end
end

