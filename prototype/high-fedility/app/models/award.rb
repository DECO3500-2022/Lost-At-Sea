class Award < ApplicationRecord
    enum award_type: %w[medal trophy]

    belongs_to :user
    belongs_to :backer, class_name: "User"

    belongs_to :post, optional: true
    belongs_to :comment, optional: true

    def awarded_on_to_s
        s = 'undefined'
        s = 'post' if !self.post.nil?
        s = 'comment' if !self.comment.nil?
        return s
    end
    
    def course_awarded_on_to_s
        s = self.awarded_on_to_s
        if s == 'post'
            return self.post.course.to_s
        end
        if s== 'comment'
            return self.comment.post.course.to_s
        end
        return s
    end

    def to_s
        return "#{self.backer.full_name_to_s} gave you a #{self.award_type} on a #{self.awarded_on_to_s} in #{self.course_awarded_on_to_s}"
    end

end
