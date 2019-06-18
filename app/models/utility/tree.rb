class Tree
  attr_accessor :root_node
  def initialize(root_value, root_leaves=nil)
    @root_node = Node.new(root_value, root_leaves)
  end

  def insert(target_node, new_nodes)
    target_node.leaves += new_nodes
  end
end
