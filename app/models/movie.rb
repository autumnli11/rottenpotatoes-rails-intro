class Movie < ActiveRecord::Base

    @@all_ratings = ['G', 'PG13']
    def self.get_all_ratings
        @@all_ratings
    end
end
