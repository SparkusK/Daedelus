class Search::Filter::AbstractFilter
  def initialize
  end

  def apply(relation)
    relation
  end

  private

  def arg_exists?(arg)
    !(arg.nil? || arg.empty?)
  end
end
