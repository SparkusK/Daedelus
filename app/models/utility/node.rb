class Node
  attr_reader :value
  attr_accessor :leaves

  def initalize(value, leaves=[])
    @value = value
    @leaves = leaves
  end

end
