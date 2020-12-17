class Api::V1::RelatedFilmsController < ApplicationController
  def index
    render json: FilmsService.new.find_films_by_game(params[:game_id])
  end
end
