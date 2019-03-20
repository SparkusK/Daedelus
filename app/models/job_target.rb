class JobTarget < ApplicationRecord
  belongs_to :section
  belongs_to :job

  def get_available_amount
    total = self.job.total
    payments = JobTarget.where(job_id: self.job_id).sum(target_amount)
    total - payments
  end

  def get_removal_confirmation(job_target_id)
    "Performing this action will permanently delete this record from the database. Are you sure?"
  end
end
