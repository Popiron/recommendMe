class Api::V1::RelatedGamesController < ApplicationController
  def index
    render json: GamesService.new.find_games_by_film(params[:film_id])
  end
end
