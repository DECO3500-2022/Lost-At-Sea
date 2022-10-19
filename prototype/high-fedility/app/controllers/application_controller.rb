class ApplicationController < ActionController::Base
    helper_method :current_user

    def current_user
        if session[:user_id]
          @current_user ||= User.find(session[:user_id])
        else
          @current_user = nil
        end
      end

    private

    def not_found
        raise ActionController::RoutingError.new('404 Not Found')
    end

    def is_admin?
        not_found unless current_user.admin?
    end
    
    def is_lecturer?
      not_found unless current_user.lecturer?
    end

    def is_tutor?
      not_found unless current_user.tutor?
    end

    def is_student?
      not_found unless current_user.tutor?
    end

    def is_not_student?
      not_found unless current_user.admin? or current_user.lecturer? or current_user.tutor?
    end

    def sessioned?
        redirect_back(fallback_location: landing_path) if current_user
    end

    def is_admin?
        not_found unless current_user.admin?
    end

    def correct_user?
      redirect_to landing_path unless current_user = User.find(params[:id])
    end

    def activated?
      redirect_to activate_path unless current_user.activated?
    end

    def logged_in?
      redirect_to login_path if current_user.nil?
    end

    def RMQ_send_message(host, queue, message)
      producer = RabbitMQInterface::Producer.new(host, queue)
      producer.send(message)
    end

end
