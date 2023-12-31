module Utility
  class Node
    attr_accessor :leaves, :value

    def initialize(value, leaves=[])
      @value = value
      @leaves = leaves
    end

    def is_branch?
      self.has_leaves?
    end

    def has_leaves?
      !(@leaves.nil? || @leaves.empty?)
    end
  end
end
