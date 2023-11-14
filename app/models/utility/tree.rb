module Utility
  class Tree
    attr_accessor :root_node
    def initialize(root_value, root_leaves=nil)
      @root_node = Node.new(root_value, root_leaves)
    end

    def root_is_leaf?
      !@root_node.is_branch?
    end
  end
end
