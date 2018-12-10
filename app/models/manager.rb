class Manager < ApplicationRecord
  belongs_to :employee
  belongs_to :section


  def manager_name
    "#{employee.first_name} #{employee.last_name}"
  end

  def self.search(keywords)

    search_term = keywords.downcase + '%'

    if search_term.split.length > 1 # search_term has spaces
      where_term = %{
        (lower(employees.first_name) || ' ' || lower(employees.last_name)) LIKE ?
        OR lower(sections.name) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "last_name asc"

      Manager.joins(:employee, :section)
      .where(
        where_term,
        search_term,
        search_term
      ).order(order_term)
    else
      where_term = %{
        lower(employees.first_name) LIKE ?
        OR lower(employees.last_name) LIKE ?
        OR lower(sections.name) LIKE ?
      }.gsub(/\s+/, " ").strip

      order_term = "last_name asc"

      Manager.joins(:employee, :section)
      .where(
        where_term,
        search_term,
        search_term,
        search_term
      ).order(order_term)
    end
  end
end
