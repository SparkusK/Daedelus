class Job < ApplicationRecord
  validates :targeted_amount, numericality: { less_than_or_equal_to: :total, message: "must be less than or equal to Total" }
  belongs_to :section
  has_many :creditor_orders
  has_many :debtor_orders
  has_many :labor_records

  def get_supervisor
    Supervisor.find_by(section_id: section.id)
  end

  def job_name
    "#{jce_number}"
  end

  def get_receive_date_string
    self.receive_date.nil? ? "" : self.receive_date.strftime("%a, %d %b %Y")
  end

  def still_available_amount
    self.total - self.targeted_amount
  end

  # Search by:
  #   sections.name,
  #   jobs.contact_person,
  #   jobs.responsible_person,
  #   jobs.work_description (if " ".count > 1)
  #   quotations.code
  #   jobs.jce_number
  def self.search(keywords, start_date, end_date, page, show_finished)
    if show_finished.nil?
      show_finished = false
    elsif show_finished == "1" || show_finished == true || show_finished == 1
      show_finished = true
    else
      show_finished = false
    end


    if start_date.nil? || end_date.nil?
      if keywords.nil?
        order_term = "jobs.receive_date desc"
        Job.where(
          "jobs.is_finished = ?", show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      elsif keywords =~ /\d/
        search_term = '%' + keywords.downcase + '%'
        where_term = %{
          lower(jobs.jce_number) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          OR lower(quotation_reference) LIKE ?
          AND jobs.is_finished = ?
        }.gsub(/\s+/, " ").strip

        order_term = "jobs.receive_date desc"

        Job.where(
          where_term,
          search_term,
          search_term,
          search_term,
          show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      else
        # search everything
        search_term = '%' + keywords.downcase + '%'
        where_term = %{
          lower(sections.name) LIKE ?
          OR lower(jobs.contact_person) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          OR lower(jobs.work_description) LIKE ?
          OR lower(quotation_reference) LIKE ?
          OR lower(jobs.jce_number) LIKE ?
          AND jobs.is_finished = ?
        }.gsub(/\s+/, " ").strip

        order_term = "jobs.receive_date desc"

        Job.joins(
          :section
        ).where(
          where_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      end
    else
      if keywords.nil?
        where_term = "target_date >= ? AND target_date <= ? AND jobs.is_finished = ?"
        order_term = "jobs.target_date desc"
        Job.where(
          where_term,
          start_date,
          end_date,
          show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      # If there are numbers, we only search:
      #   JCE number, responsible_person, quotation code
      elsif keywords =~ /\d/
        search_term = '%' + keywords.downcase + '%'
        where_term = %{
          lower(jobs.jce_number) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          OR lower(quotation_reference) LIKE ?
          AND target_date >= ? AND target_date <= ?
          AND jobs.is_finished = ?
        }.gsub(/\s+/, " ").strip

        order_term = "jobs.receive_date desc"

        Job.where(
          where_term,
          search_term,
          search_term,
          search_term,
          start_date,
          end_date,
          show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      else
        # search everything
        search_term = '%' + keywords.downcase + '%'
        where_term = %{
          (lower(sections.name) LIKE ?
          OR lower(jobs.contact_person) LIKE ?
          OR lower(jobs.responsible_person) LIKE ?
          OR lower(jobs.work_description) LIKE ?
          OR lower(quotation_reference) LIKE ?
          OR lower(jobs.jce_number) LIKE ?)
          AND target_date >= ? AND target_date <= ?
          AND jobs.is_finished = ?
        }.gsub(/\s+/, " ").strip

        order_term = "jobs.receive_date desc"

        Job.joins(
          :section
        ).where(
          where_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          search_term,
          start_date,
          end_date,
          show_finished
        ).order(
          order_term
        ).paginate(
          page: page
        ).includes(
          :section
        )
      end
    end
  end
end
