module RemovalConfirmationBuilder
  extend ActiveSupport::Concern

  class_methods do
    def compute_dependency_tree
      tree = Utility::Tree.new(self)
      compute_leaves(tree.root_node)
    end

    private

    def compute_leaves(starting_node)
      starting_node.leaves = leaf_classes(starting_node.value)
      starting_node.leaves.each { |node| compute_leaves(node) }
    end

    def to_node(klass)
      Node.new(klass)
    end

    def to_class(symbol)
      symbol.to_s.classify.constantize
    end

    def leaf_classes(klass)
      klass.reflect_on_all_associations(:has_many).map(&:name).map { |symbol| to_node(to_class(symbol)) }
    end
  end
end
