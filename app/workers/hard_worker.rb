class HardWorker
  include Sidekiq::Worker
  def perform
    FilmsService.new.fill_films_db
    GamesService.new.fill_games_db
  end
end
