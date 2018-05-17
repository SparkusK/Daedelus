class Section < ApplicationRecord
  has_many :employees
  has_many :jobs
  has_many :supervisors
  has_one :manager

  def section_name
    "#{name}"
  end


end
