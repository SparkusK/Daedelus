class Search::Filter::KeywordFilter < Search::Filter::AbstractFilter
  def initialize(attributes, keywords, search_term=lambda {"%" + @keywords.downcase + "%"})
    @search_term = search_term
    @keyword_attributes = attributes
    @keywords = keywords
  end

  def apply(relation)
    if arg_exists?(@keyword_attributes) && arg_exists?(@keywords)
      relation.where(where_term, keywords: @search_term.call)
    else
      relation
    end
  end

  private

  def where_term
    case
    when @keyword_attributes.length == 1
      where_term_one_attribute
    when @keyword_attributes.length > 1
      where_term_many_attributes
    else
      raise KeywordFilterError,
        "Keyword search attributes need to exist and be valid"
    end
  end

  def where_line(attribute, options={})
    options = where_line_defaults.merge(options)

    line = ""
    line << ( options[:is_start] ?  "(" : " OR " )
    line << "lower(" if options[:is_lower]
    line << attribute
    line << ")" if options[:is_lower]
    line << " LIKE :keywords"
    line << ")" if options[:is_end]
    line
  end

  def where_term_many_attributes
    where_term = ""

    first_attribute = @keyword_attributes.first
    last_attribute = @keyword_attributes.last
    middle_attributes = @keyword_attributes.slice(1..-2)

    where_term << where_line(first_attribute, is_start: true)
    middle_attributes.each do |attribute|
      where_term << where_line(attribute)
    end
    where_term << where_line(last_attribute, is_end: true)
  end

  def where_term_one_attribute
    where_term = where_line(@keyword_attributes.first, is_start: true, is_end: true)
  end

  def where_line_defaults
    { is_start: false, is_end: false, is_lower: true }
  end

end
