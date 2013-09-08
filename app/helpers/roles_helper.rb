module RolesHelper

  # format square labels for roles
  def role_label access
    role = :role_user
    if access.has_role? :owner
      role = :role_owner
    elsif access.has_role? :master
      role = :role_master
    elsif access.has_role? :admin
      role = :role_admin
    end
    html = "<div class='role #{role}'>#{ t(role) }</div>"
    html.html_safe
  end
end