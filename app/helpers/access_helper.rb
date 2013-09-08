module AccessHelper

  def link_to_access_activation(access)
    label = access.active ? t('access.deactivate') : t('access.activate')
    link_to label, admin_company_access_activation_path(access.company_id,access.id), :remote => true
  end

  def link_to_access_resend_invitation(access)
    label = t('access.resend_now')
    link_to label, admin_company_access_resend_invitation_path(access.company_id,access.id), :remote => true
  end

end