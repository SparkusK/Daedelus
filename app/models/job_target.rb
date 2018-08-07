class JobTarget < ApplicationRecord
  belongs_to :job
  belongs_to :section
end
