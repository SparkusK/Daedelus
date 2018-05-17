class Manager < ApplicationRecord
  belongs_to :employee
  belongs_to :section
end
