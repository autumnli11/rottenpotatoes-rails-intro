class Movie < ActiveRecord::Base

    @@all_ratings = self.find(:first, :group => "rating").map(&:rating)
    def self.get_all_ratings
        @@all_ratings
    end
end
