class Api::V1::GamesController < ApplicationController
  def index
    GamesService.new.fill_games_db
    @games = Game.all
    render json: @games
  end
end
