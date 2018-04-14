class LaborRecord < ApplicationRecord
  belongs_to :employee
  has_one :supervisor
  belongs_to :job
end
