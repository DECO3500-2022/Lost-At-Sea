class UsersController < ApplicationController

    before_action :logged_in?, only: %i[index show edit update destory]

    before_action :sessioned?, only: %i[new create]

    before_action :set_user, only: %i[show edit update destroy]
    before_action :correct_user?, only: %i[show edit update destory]


    def show
    end
  
    def index
        @users = User.all
    end
  
    def new
      @user = User.new
    end

    def activate
    end

    def activated
        if params[:code] == current_user.register_code
            current_user.activate
            flash[:success] = "true"
            flash[:message] = "Account successfully activated"
            redirect_to user_path(current_user.id)
        else
            flash[:success] = "false"
            flash[:message] = "Incorrect 6-digit code"
            redirect_to activate_path
        end
    end

    def regenerate_code
        current_user.regenerate_regsiter_code
        redirect_to activate_path
    end
  
    def create
        @user = User.create(user_params)

        if @user.valid?
            
            session[:user_id] = @user.id
            flash[:success] = "true"
            flash[:message] = "Successfully created an account."
            redirect_to "/"
        else
            flash[:success] = "false"
            flash[:message] = "An error occured while creating an account. Please try again."
            flash[:errors] = @user.errors
            redirect_to register_path
        end
    end
  
    private 
    def set_user
        if params[:id]
          @user = User.find(params[:id])
        else
          @user = User.find(params[:user_id])
        end
      end
    
    def user_params
        params.require(:user).permit(
          :email,
          :first_name,
          :last_name,
          :password,
          :password_confirmation
        )
    end
  
    def correct_user?
        not_found unless current_user == @user or current_user.admin?
    end

end