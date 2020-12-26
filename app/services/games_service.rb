require 'uri'
require 'net/http'
require 'openssl'

class GamesService

  def fill_games_db
    # fill_game_genres_db

    #Game.delete_all
    list_of_games

  end

  def find_games_by_film(filmId)
    genres = JSON.parse(Film.find_by_film_id(filmId).genres)
    array = Array.new
    genres.each do |g|
      res = find_games_by_genre(FilmGenre.find_by_name(g).genre_id)
      if res!= nil
      array = array.union(res)
      end
    end
    array
  end

  private

  def find_games_by_genre(genre_id)
    game_genre = GameGenre.find_by_genre_id(genre_id)
    if game_genre!=nil
      name = game_genre.name
      Game.find_by_sql("SELECT * FROM games WHERE genres LIKE '%#{name}%'")
    end
  end

  def fill_game_genres_db
    GameGenre.delete_all
    games_data = game_genres
    games_data.each do |f|
      @game_genre = GameGenre.new(f)
      @game_genre.save!
    end
  end

  def list_of_games(http="https://rawg-video-games-database.p.rapidapi.com/games",cnt=0)
   url = URI(http)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV['GAMES_API_KEY']
    request["x-rapidapi-host"] = 'rawg-video-games-database.p.rapidapi.com'

    response = http.request(request)

   next_page = JSON.parse(response.read_body)["next"]

   if next_page != nil && cnt!=4
     cnt=cnt+1
     list_of_games(next_page,cnt)
   end

   games_data = JSON.parse(response.read_body)["results"].map { |e|
     {title: e['name'],
      release_date: e['released'],
      rating: e['rating'],
      genres:e['genres'].map {|q|q['name'] },
      game_id:e['id'],
      background_image:e['background_image'],
      description:game_details(e['id'])
     }
   }

   games_data.each do |f|
     @game = Game.new(f)
     @game.save!
   end

  end

  def game_details(gameId)
    url = URI("https://rawg-video-games-database.p.rapidapi.com/games/#{gameId}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV['GAMES_API_KEY']
    request["x-rapidapi-host"] = 'rawg-video-games-database.p.rapidapi.com'

    response = http.request(request)

    JSON.parse(response.read_body)["description"]

  end

  def game_genres
    url = URI("https://rawg-video-games-database.p.rapidapi.com/genres")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV['GAMES_API_KEY']
    request["x-rapidapi-host"] = 'rawg-video-games-database.p.rapidapi.com'

    response = http.request(request)

    JSON.parse(response.read_body)["results"].map do |g|
      {
      genre_id: g['id'],
      name: g['name']
      }
    end
  end

end