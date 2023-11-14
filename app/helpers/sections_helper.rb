module SectionsHelper

  def unsupervised_sections
    Section.all.select { |sec| sec if sec.supervisors.nil? }
  end

  def unmanaged_sections
    Section.all.select { |sec| sec if sec.manager.nil? }
  end

  def empty_sections
    Section.all.select { |sec| sec if sec.supervisors.nil? && sec.manager.nil? }
  end

end
