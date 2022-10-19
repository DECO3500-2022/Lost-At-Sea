class Comment < ApplicationRecord
    validates_presence_of :body

    has_ancestry

    belongs_to :post
    belongs_to :user
    
    has_many :awards, dependent: :destroy

    def awards_to_s
        return "Trophies: #{self.awards.where(award_type: 1).count} | Medals: #{self.awards.where(award_type: 0).count}"
    end

    def award_bool_to_s(user)
        if self.awards.find_by(backer: user).nil?
            return "Reward"
        else
            return "Unreward"
        end
    end

end
