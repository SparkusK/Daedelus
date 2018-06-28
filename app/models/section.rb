class Section < ApplicationRecord
  has_many :employees
  has_many :jobs
  has_many :supervisors
  has_one :manager

  def section_name
    "#{name}"
  end

  def self.search(keywords)

    search_term = keywords.downcase + '%'

    where_term = %{
      lower(name) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "name asc"

    Section.where(where_term, search_term).order(order_term)
  end

end
