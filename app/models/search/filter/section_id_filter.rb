class Search::Filter::SectionIdFilter < Search::Filter::AbstractFilter
  def initialize(section_id)
    @section_id = section_id
  end

  def apply(relation)
    arg_exists?(@section_id) ? relation.where(section_id: @section_id) : relation
  end
end
