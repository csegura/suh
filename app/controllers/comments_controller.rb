class CommentsController < ApplicationController
  include Security
  respond_to :html, :js

  before_filter :load_comment, :only => [:show, :destroy]

  # GET  /comments/:id(.:format)
  # redirect to commentable
  def show
    redirect_to polymorphic_url(@comment.commentable) + "#comment_#{params[:id]}"
  rescue
    flash[:alert] = t('comment.not_found')
    redirect_to :back
  end

  # document_comments POST   /documents/:document_id/comments(.:format)
  # issue_comments POST   /issues/:issue_id/comments(.:format)
  def create
    @commentable = find_commentable
    @comment     = @commentable.comments.build(params[:comment]) do |comment|
                    comment.access = current_access
                   end
    if @comment.save
      flash.now[:notice] = t('comment.added')
      Rails.logger.info @comment.inspect
      @counter = @commentable.comments.count
      respond_with @comment
    else
      Rails.logger.info @comment.errors.messages
      flash.now[:error] = t('comment.added.error')
    end
  end

  def destroy
    @comment.move_to_trash
    @commentable = @comment.commentable
    @counter     = @commentable.comments.not_in_trash.count
  end

private

  def load_comment
    @comment = Comment.find(params[:id], :include => [:documents])
    check_access_for @comment.commentable
  end

  # finds a matching parameter it calls classify on the part of the name
  # before the _id to turn in it from a table name in to a model name
  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end