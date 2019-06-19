module RemovalConfirmationBuilder
  extend ActiveSupport::Concern

  class_methods do
    def build_removal_confirmation(id)
      removal_confirmation = ""
      tree = compute_dependency_tree(id)
      if tree.root_is_leaf?
        removal_confirmation += "Performing this action will permanently delete this #{tree.value.to_s}."
        removal_confirmation += "\nAre you sure?"
      else
        removal_confirmation += "Performing this action will delete the following:\n"
        removal_confirmation += generate_removal_lines(tree.root_node)
        removal_confirmation += "Are you sure?"
      end
    end

    private

    def format_node_to_s(node)
      node.value.to_s.underscore.humanize.pluralize
    end

    def generate_removal_lines(starting_node, removal_string="", indentation=0, spaces=2)
      removal_string += " "*(spaces*indentation) + "*" +
        starting_node.value.ids.count + " " + format_node_to_s(starting_node) + "\n"
      starting_node.leaves.each { |node| generate_removal_lines(node, removal_string, indentation+1)}
    end

    def compute_dependency_tree(id)
      tree = Utility::Tree.new(RemovalNode.new(self, [id]))
      compute_leaves(tree.root_node)
    end

    def compute_leaves(starting_node)
      starting_node.leaves = leaf_classes(starting_node)
      starting_node.leaves.each { |node| compute_leaves(node) }
    end

    def leaf_classes(parent_node)
      assocs = parent_node.klass.reflect_on_all_associations(:has_many).map {
        |assoc| {name: assoc.name, options: assoc.options} }
      on_delete_classes = assocs.select { |assoc| assoc[:options][:dependent] == :delete_all }
      nodes = on_delete_classes.map { |assoc| to_node(to_class(assoc.name)) }
      nodes = populate_node_ids(nodes, parent_node)
      nodes
    end

    def populate_node_ids(nodes, parent_node)
      nodes.each do |node|
        fk_sym = class_to_fk_sym(klass)
        node.ids = node.klass.select("id").where(fk_sym: ids)
      end
      nodes
    end

    def to_node(klass)
      Node.new(RemovalNode.new(klass))
    end

    def to_class(symbol)
      symbol.to_s.classify.constantize
    end

    def class_to_fk_sym(klass)
      (klass.to_s.downcase + "_id").to_sym
    end
  end
end
