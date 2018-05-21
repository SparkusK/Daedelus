class LaborRecord < ApplicationRecord
  belongs_to :employee
  belongs_to :supervisor, optional: true
  belongs_to :job
end
