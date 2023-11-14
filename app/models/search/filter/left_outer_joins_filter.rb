class Search::Filter::LeftOuterJoinsFilter < Search::Filter::AbstractFilter
  def initialize(joins_list=nil)
    @joins_list = joins_list
  end

  def apply(relation)
    relation.left_outer_joins(@joins_list)
  end

end
