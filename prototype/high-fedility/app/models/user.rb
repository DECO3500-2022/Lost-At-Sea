class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates_presence_of :first_name, :last_name

    has_many :enrollment, dependent: :destroy
    has_many :courses, through: :enrollment

    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :awards, dependent: :destroy

    before_save :generate_register_code

    enum role: %w[student tutor lecturer admin]

    def activate
        self.activated = true
        self.save
    end

    def deactivate
        self.activated = false
        self.save
    end

    def generate_register_code
        code = ""
        6.times do
            code += rand(0..9).to_s
        end
        self.register_code = code
    end

    def regenerate_regsiter_code
        self.generate_register_code
        self.save
    end

    def has_award(backer, post, comment)
        if Award.find_by(user: self, backer: backer, post: post, comment: comment).nil?
            return false
        else
            return true
        end
    end

    def get_award(backer, post, comment)
        award = Award.new
        award.user = self
        award.backer = backer
        award.post = post
        award.comment = comment
        if backer.role_before_type_cast != 0
          award.award_type = 1
        end
        award.save
    end

    def toggle_reward(backer, post, comment)
        award = Award.find_by(user: self, backer: backer, post: post, comment: comment)
        if award.nil?
            self.get_award(backer, post, comment)
        else
            award.destroy
        end
    end

    def full_name_to_s
        return "#{self.first_name} #{self.last_name}"
    end

    def awards_to_s
        awards = self.awards.all
        return "Trophies : #{awards.where(award_type: 1).count} | Medals: #{awards.where(award_type: 0).count}"
    end

    def trophies_to_s
        return "Trophies : #{self.awards.where(award_type: 1).count}"
    end

    def medals_to_s
        return "Medals : #{self.awards.where(award_type: 0).count}"
    end

    def to_s
        return "#{self.full_name_to_s} (#{self.awards_to_s})"
    end

end
