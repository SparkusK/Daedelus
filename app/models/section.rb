class Section < ApplicationRecord
  has_many :employees
  has_many :jobs
  has_many :supervisors
  has_one :manager

  def section_name
    "#{name}"
  end

  # Search by name
  def fuzzy_search(params)

  end

end
