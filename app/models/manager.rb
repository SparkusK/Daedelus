class Manager < ApplicationRecord
  include Searchable
  belongs_to :employee
  belongs_to :section

  def manager_name
    "#{employee.first_name} #{employee.last_name}"
  end

  private

  def self.keyword_search_attributes
    [ "employees.first_name || ' ' || employees.last_name", "sections.name" ]
  end

  def self.subclassed_order_term
    "employees.first_name asc"
  end

  def self.subclassed_join_list
    [ :employee, :section ]
  end

  def self.subclassed_includes_list
    [ :employee, :section ]
  end
end
