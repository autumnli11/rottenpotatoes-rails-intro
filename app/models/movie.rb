class Movie < ActiveRecord::Base

    @@all_ratings = self.find(:all, :group => "rating").map(&:rating)
    def get_all_ratings
        @@all_ratings
    end
end
