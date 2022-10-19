class SessionsController < ApplicationController

    before_action :sessioned?, only: %i[new create]

    before_action :logged_in?, only: %i[destory]

    def new
    end

    def create
        session_params = params.permit(:email, :password)
        @user = User.find_by(email: session_params[:email])
        if @user && @user.authenticate(session_params[:password])
            flash[:success] = "true"
            flash[:message] = "Logged in sucessfully!"
            session[:user_id] = @user.id
            redirect_to "/"
        else
            flash[:success] = "false"
            flash[:message] = "Email or password is incorrect!"
            redirect_to login_path
        end
    end

    def destroy
        flash[:success] = "true"
        flash[:message] = "Sucessfully logged out."
        session.delete(:user_id)
        redirect_to landing_path
    end

end
