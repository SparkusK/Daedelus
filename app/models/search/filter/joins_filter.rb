class Search::Filter::JoinsFilter < Search::Filter::AbstractFilter
  def initialize(joins_list=nil)
    @joins_list = joins_list
  end

  def apply(relation)
    relation.joins(@joins_list)
  end

end
