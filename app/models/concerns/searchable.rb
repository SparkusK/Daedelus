module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def search(args)
      args = search_defaults.merge(args)
      args = subclassed_search_defaults.merge(args)
      @relations = self.all
      filters = build_filters(args)
      filters.each { |filter| @relations = filter.apply(@relations) }
      @relations
    end

    private

    def search_defaults
      { keywords: nil, page: 1 }
    end

    def default_order_term
      "updated_at desc"
    end

    def build_filters(args)
      filters = []
      filters << Search::Filter::KeywordFilter.new(keyword_search_attributes, args[:keywords])
      filters << Search::Filter::JoinsFilter.new(subclassed_join_list)
      filters << Search::Filter::LeftOuterJoinsFilter.new(subclassed_left_outer_joins_list) unless subclassed_left_outer_joins_list.nil?
      filters = filters + subclassed_filters(args) unless subclassed_filters(args).nil?
      filters << Search::Filter::OrderFilter.new(subclassed_order_term)
      filters << Search::Filter::PaginationFilter.new(args[:page])
      filters << Search::Filter::IncludesFilter.new(subclassed_includes_list)
      filters
    end

    # Required
    def keyword_search_attributes
      raise NotImplementedError
    end

    def subclassed_filters(args)
      nil
    end

    def subclassed_search_defaults
      {}
    end

    def subclassed_order_term
      default_order_term
    end

    def subclassed_left_outer_joins_list
      nil
    end

    def subclassed_join_list
      nil
    end

    def subclassed_includes_list
      nil
    end
  end
end
