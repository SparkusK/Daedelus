module SectionsHelper

  def unsupervised_sections
    Section.all.select { |sec| sec if sec.supervisor.nil? }
  end

end
