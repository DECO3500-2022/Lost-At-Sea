class CommentsController < ApplicationController
  before_action :logged_in?

  before_action :get_course
  before_action :get_post
  before_action :set_comment, only: %i[show edit update destroy award]

  before_action :can_modify?, only: %i[edit update]
  before_action :can_delete?, only: %i[destroy]

  before_action :awardable?, only: %i[award]

  def index
    @comments = @post.comments
  end

  def show
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.post = @post
    if @comment.save
      flash[:success] = "true"
      flash[:message] = "Successfully left a comment."
      redirect_to course_post_path(@course, @post)
    else
      flash[:success] = "false"
      flash[:message] = "An error occured while leaving a comment. Please try again."
      flash[:errors] = @comment.errors
      redirect_to new_course_post_comment_path
    end
  end

  def update
    params[:comment][:parent_id] = @comment.parent_id
    if @comment.update(comment_params)
      flash[:success] = "true"
      flash[:message] = "Successfully updated the comment"
      redirect_back(fallback_location: course_post_path(@course, @post))
    else
      flash[:success] = "false"
      flash[:message] = "An error occured while updating a comment. Please try again."
      redirect_to edit_course_post_comment_path
    end
  end

  # DELETE /comments/1
  def destroy
    flash[:message] = "Comment has been deleted."
    @comment.destroy
    redirect_to course_post_path(@course, @post)
  end

  def award
    @comment.user.toggle_reward(current_user, nil, @comment)
    redirect_back(fallback_location: course_post_path(@course, @post))
  end

  private
    def set_comment
      if params[:id]
        @comment = Comment.find(params[:id])
      else
        @comment = Comment.find(params[:comment_id])
      end
    end

    def comment_params
      params.require(:comment).permit(:body, :parent_id)
    end

    def get_course
      @course = Course.find(params[:course_id])
    end

    def get_post
      @post = Post.find(params[:post_id])
    end

    def can_modify?
      not_found unless @comment.user == current_user
    end

    def can_delete?
      not_found unless @comment.user == current_user or !current_user.student?
    end

    def awardable?
      redirect_back(fallback_location: course_post_path(@course, @post)) if @comment.user == current_user
    end

end
