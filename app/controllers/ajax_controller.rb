class AjaxController < ApplicationController
  include Security
  respond_to :json
  before_filter :login_required

  def unread_count
    activities = Activity.load_activities current_access
    unread_count = activities.unread(current_user).count
    respond_with :unread_count => unread_count
  end

  def accesses_in_company
    accesses = Access.find_all_by_company_id(params[:id])
    respond_with accesses.map { |c| [c.full_name, c.id] }
  end

end