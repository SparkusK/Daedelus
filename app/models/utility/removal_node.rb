class RemovalNode
  attr_accessor :klass, :ids
  def initialize(klass, ids=[])
    @klass = klass
    @ids = ids
  end
end
