class DocumentsController < ApplicationController
  include Security
  respond_to :html, :js

  before_filter :login_required
  before_filter :load_document, :only => [:show, :download, :destroy]

  def index
    load_documents
    respond_with(@documents)
  end

  def show
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.create_new current_user_company, current_access, params[:document]

    if @document.save
      flash[:notice] = t('document.added')
      respond_with @file, :location => documents_path
    else
      Rails.logger.info @file.errors.messages
      render :new
    end
  end

  # PUT /download
  def download
    #document = Document.find(params[:document_id])
    # revise security
    if @document
      send_file @document.asset.path, :type=> @document.asset_content_type, :x_sendfile=>true
    else
      redirect_to :root, :status => 404
    end
  end

  private

  def load_documents
    @documents = load_by_access Document
    @documents_months = @documents.get_months

    @documents = @documents.for_company_in_main_company(current_company,params[:company]) if filter :company
    @documents = @documents.for_month(Date.parse(params[:month])) if filter :month
    @documents = @documents.for_category_id(params[:category]) if filter :category

    @documents = @documents.paginate :page => params[:page],
                             :per_page => Document.per_page
  end

  def load_document
    Rails.logger.info "** init"
    @document = Document.find(params[:id], :include => [:comments])

    check_access_for @document

    @comments = params[:trash] ? @document.comments : @document.comments.not_in_trash
    @comments_count = @comments.count
    @comments_in_trash_count = @document.comments.in_trash.count

    Rails.logger.info "*****"

  end
end