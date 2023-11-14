class Search::Filter::DateRangeFilter < Search::Filter::AbstractFilter
  def initialize(attribute, date_range)
    @attribute = attribute
    @date_range = date_range
  end

  def apply(relation)
    if @date_range.has_start?
      relation = relation.where("#{@attribute} >= ?", @date_range.start_date)
    end
    if @date_range.has_end?
      relation = relation.where("#{@attribute} <= ?", @date_range.end_date)
    end
    relation
  end

end
