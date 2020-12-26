class Api::V1::FilmsController < ApplicationController
  def index
    FilmsService.new.fill_films_db
    @films = Film.all
    render json: @films
  end
end
