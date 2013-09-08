class Admin::CategoriesController < ApplicationController
  respond_to :html, :js
  before_filter :login_required

  def index
    @categories = Category.for_company(current_company)
    @category = Category.new
  end

  def create
    @category = current_company.categories.create(params[:category])
    if @category.save
      respond_with @category
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    respond_with @category
  end

  def sort
    params[:category].each_with_index do |id, index|
      Rails.logger.info id, index
      Category.find(id).update_attribute(:position, index+1)
    end
    render :nothing => true
  end

  def rename
    unless params[:value].blank?
      id = params[:id].scan(/_(\d+)/)[0][0]
      @category = Category.find(id)
      @category.update_attribute(:name, params[:value])
      render :text=>params[:value]
    end
  end

end
