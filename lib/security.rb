module Security

  def load_by_access model
    Rails.logger.info ">> load_by_access "
    if model.respond_to?(:public_access)
    end
    if current_access.is_owner?
       Rails.logger.info "as owner #{current_company.name}"
       model.for_main_company(current_company)
    elsif current_access.is_admin?
       Rails.logger.info "as admin #{current_user_company.name}"
       model.for_company(current_user_company)
    else
      Rails.logger.info "as user #{current_user.full_name}"
       model.for_user_access(current_user)
    end
  end

  def check_access_for resource
    if resource.access_id == current_access.id
      return true
    end
    if current_access.is_owner? &&
       resource.access.company.main_company_id == current_company.id
      return true
    end
    if current_access.is_admin? &&
       resource.company_id == current_user_company.id
      return true
    end
    if current_access.is_user? &&
      resource.access.user_id == current_user.id
      return true
    end
    flash[:alert] = t('label.access_denied')
    redirect_to :action => :index and return
    false
  end


end