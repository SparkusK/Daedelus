class Search::Filter::OrderFilter < Search::Filter::AbstractFilter
  def initialize(order_term="updated_at desc")
    @order_term = order_term
  end

  def apply(relation)
    relation.order(@order_term)
  end
end
