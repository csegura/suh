class MeController < ApplicationController
  layout "me"
  respond_to :html, :js

  before_filter :login_required

  # GET /me
  def show
    Rails.logger.info "**"
    @accesses = Access.for_user(current_user)
    @accesses = @accesses.paginate :page => params[:page],
                                   :per_page => Access.per_page
  end

end