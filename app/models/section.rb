class Section < ApplicationRecord
  has_many :employees
  has_many :jobs
  has_one :supervisor

  def section_name
    "#{name}"
  end


end
