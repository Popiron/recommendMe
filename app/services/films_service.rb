require 'uri'
require 'net/http'
require 'openssl'
require 'active_support'

class FilmsService

  def fill_films_db
    # fill_film_genres_db

    Film.delete_all
    all_films

  end

  def find_films_by_game(gameId)
    genres = JSON.parse(Game.find_by_game_id(gameId).genres)
    array = Array.new
    genres.each do |g|
      res = find_films_by_genre(GameGenre.find_by_name(g).genre_id)
      if res!= nil
        array = array.union(res)
      end
    end
    array
  end



  private

  def fill_film_genres_db
    FilmGenre.delete_all
    film_genres_data = film_genres
    film_genres_data.each do |f|
      @film_genre = FilmGenre.new(f)
      @film_genre.save!
    end
  end

  def find_films_by_genre(genreId)
    film_genre = FilmGenre.find_by_genre_id(genreId)
    if film_genre!=nil
      name = film_genre.name
      Film.find_by_sql("SELECT * FROM films WHERE genres LIKE '%#{name}%'")
    end
  end

  def all_films(page=1)
    fill_films_db
      url = URI("https://api.themoviedb.org/3/discover/movie?api_key=#{ENV['FILMS_API_KEY']}&language=en-US&sort_by=popularity.desc&page=#{page}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)

      response = http.request(request)

      if page != 5
        page = page + 1
        all_films(page)
      end

      film_data = JSON.parse(response.read_body)["results"].map { |e|
        {title: e['title'],
         release_date: e['release_date'],
         description:e['overview'],
         genres:e['genre_ids'].map {|g|
           FilmGenre.find_by_genre_id(g).name
        },
         film_id:e['id'],
         background_image: e['backdrop_path'] == nil ? "" : "https://image.tmdb.org/t/p/original"+e['backdrop_path'],
         rating:e['vote_average'],
         poster: "https://image.tmdb.org/t/p/original"+e["poster_path"]
        }
      }

      film_data.each do |f|
        @film = Film.new(f)
        @film.save!
      end

  end

  def film_genres
    url = URI("https://api.themoviedb.org/3/genre/movie/list?api_key=#{ENV['FILMS_API_KEY']}&language=en-US")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    JSON.parse(response.read_body)["genres"].map do |e|
      {
          genre_id: e['id'],
          name:e['name']
      }
    end
  end





end