class Search::Filter::IncludesFilter < Search::Filter::AbstractFilter
  def initialize(includes_list=nil)
    @includes_list = includes_list
  end

  def apply(relation)
    relation.includes(@includes_list)
  end

end
