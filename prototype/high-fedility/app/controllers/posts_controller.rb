class PostsController < ApplicationController
  before_action :logged_in?

  before_action :get_course
  before_action :set_post, only: %i[show edit update destroy award]

  before_action :can_modify?, only: %i[edit update]
  before_action :can_delete?, only: %i[destroy]

  before_action :awardable?, only: %i[award]

  def index
    @posts = @course.posts
  end

  def show
  end

  def new
    @post = @course.posts.build
  end

  def edit
  end

  def create
    @post = @course.posts.build(post_params)
    @post.user = current_user

    if @post.save
      flash[:success] = "true"
      flash[:message] = "Successfully created a post."
      redirect_to course_path(@course)
    else
      flash[:success] = "false"
      flash[:message] = "An error occured while creating a course. Please try again."
      flash[:errors] = @post.errors
      redirect_to new_course_post_path
    end
  end

  def update
    if @post.update(post_params)
      flash[:success] = "true"
      flash[:message] = "Successfully updated the post."
      redirect_back(fallback_location: course_path(@course))
    else
      flash[:success] = "false"
      flash[:message] = "An error occured while editing the post. Please try again."
      flash[:errors] = @post.errors
      redirect_to edit_course_posts_path
    end
  end

  def destroy
    flash[:message] = "Post has been deleted."
    @post.destroy
    redirect_to course_path(@course)
  end

  def award
    @post.user.toggle_reward(current_user, @post, nil)
    redirect_back(fallback_location: course_path(@course))
  end

  private
    def set_post
      if params[:id]
        @post = @course.posts.find(params[:id])
      else
        @post = @course.posts.find(params[:post_id])
      end
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end

    def get_course
      @course = Course.find(params[:course_id])
    end

    def can_modify?
      not_found unless @post.user == current_user
    end

    def can_delete?
      not_found unless @post.user == current_user or !current_user.student?
    end

    def awardable?
      redirect_back(fallback_location: course_path(@course)) if @post.user == current_user
    end

end
