class LaborRecord < ApplicationRecord
  belongs_to :employee
  belongs_to :supervisor
  belongs_to :job
end
