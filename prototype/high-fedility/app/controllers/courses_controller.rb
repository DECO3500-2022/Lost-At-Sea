class CoursesController < ApplicationController

  before_action :logged_in?

  before_action :set_course, only: %i[show edit update destroy enroll]
  before_action :get_posts, only: %i[show]

  before_action :is_admin?, only: %i[new edit update destroy]

  def index
    @courses = Course.all
  end

  def show
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      flash[:success] = "true"
      flash[:message] = "Successfully created a course."
      redirect_to courses_path
    else
      flash[:success] = "false"
      flash[:message] = "An error occured while creating a course. Please try again."
      flash[:errors] = @course.errors
      redirect_to new_course_path
    end
  end

  def update
    if @course.update(course_params)
      flash[:success] = "true"
      flash[:message] = "Successfully edited the course."
      redirect_back(fallback_location: courses_path)
    else
      flash[:success] = "false"
      flash[:message] = "An error occured while editing the course. Please try again."
      flash[:errors] = @course.errors
      redirect_to edit_course_path
    end
  end

  def destroy
    flash[:message] = "Course has been deleted."
    @course.destroy
    redirect_to courses_url
  end

  def enroll
    @course.toggle_enrollment(current_user)
    redirect_back(fallback_location: course_path(@course))
  end

  private
  def set_course
    if params[:id]
      @course = Course.find(params[:id])
    else
      @course = Course.find(params[:course_id])
    end
  end

    def get_posts
      @posts = @course.posts
    end

    def course_params
      params.require(:course).permit(:code, :name)
    end

end
