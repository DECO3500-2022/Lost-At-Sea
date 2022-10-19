class Course < ApplicationRecord
    validates :code, presence: true, uniqueness: true
    validates_presence_of :name

    has_many :enrollment, dependent: :destroy
    has_many :users, through: :enrollment

    has_many :posts, dependent: :destroy

    def to_s
        return "#{self.code} | #{self.name}"
    end

    def new_enrollment(user)
        enrollment = Enrollment.new
        enrollment.user = user
        enrollment.course = self
        enrollment.save
    end

    def toggle_enrollment(user)
        enrollment = Enrollment.find_by(user: user, course: self)
        if enrollment.nil?
            self.new_enrollment(user)
        else
            enrollment.destroy
        end
    end

    def enrollment_bool_to_s(user)
        if self.enrollment.find_by(user: user).nil?
            return "Enroll"
        else
            return "Drop"
        end
    end

end
