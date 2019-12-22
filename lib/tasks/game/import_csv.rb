# docker-compose exec app bundle exec rails runner Tasks::Game::ImportCsv.execute
require "csv"

class Tasks::Game::ImportCsv
  def self.execute
    # CSV.foreach("game.csv", headers: true) do |row|
    #   kind = row['kind'].downcase
    #   kind = 'ds3' if row['kind'] == '3DS'
    #   kind = 'xbox_360' if row['kind'] == 'Xbox 360'
    #   kind = 'xbox_one' if row['kind'] == 'Xbox One'
    #   Game.new(title: row['title'], release_date_at: row['release_date_at'], publisher: row['publisher'], kind: kind, genre: row['genre2']).insert
    # end

    CSV.foreach("game-2019-ps4.csv", headers: true) do |row|
      kind = row['kind'].downcase
      Game.new(title: row['title'], release_date_at: row['release_date_at'], publisher: row['publisher'], kind: kind, genre: row['genre2']).insert
    end

    CSV.foreach("game-2020-ps4.csv", headers: true) do |row|
      kind = row['kind'].downcase
      Game.new(title: row['title'], release_date_at: row['release_date_at'], publisher: row['publisher'], kind: kind, genre: row['genre2']).insert
    end

    CSV.foreach("game-swich-2019.csv", headers: true) do |row|
      kind = row['kind'].downcase
      Game.new(title: row['title'], release_date_at: row['release_date_at'], publisher: row['publisher'], kind: kind, genre: row['genre2']).insert
    end

    CSV.foreach("game-swich-2020.csv", headers: true) do |row|
      kind = row['kind'].downcase
      Game.new(title: row['title'], release_date_at: row['release_date_at'], publisher: row['publisher'], kind: kind, genre: row['genre2']).insert
    end
  end
end