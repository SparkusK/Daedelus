class Supervisor < ApplicationRecord
  belongs_to :employee
  belongs_to :section
end
