module SupervisorsHelper
  def get_supervisors
    Supervisor.all
  end

  def get_supervisor(section_id)
    Supervisor.find_by(section_id: section_id)
  end
end
