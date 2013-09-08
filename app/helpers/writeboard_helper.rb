module WriteboardHelper

  def writeboard_content_for_version(version, current_version_number, &block)
    content_tag(:div,
                :class => (version.version_number == current_version_number) ? :current : :other,
                &block)
  end

  def writeboard_link_to_version(version, current_version_number)
    if version.version_number == current_version_number
      link_to version.version_number, writeboard_path(version.version_id)
    else
      link_to version.version_number, writeboard_version_path(version.version_id,version.version_number)
    end
  end

end