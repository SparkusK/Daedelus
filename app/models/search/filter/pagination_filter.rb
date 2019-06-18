class Search::Filter::PaginationFilter < Search::Filter::AbstractFilter
  def initialize(page)
    @page = page
  end

  def apply(relation)
    relation.paginate(page: @page)
  end
end
