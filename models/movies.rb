class Movie
  include DataMapper::Resource

  property :movie_id, Serial
  property :tmdb_id, String
  property :imdb_id, String
  property :original_title, String
  property :original_language, String
  property :overview, Text
  property :genre, String
  property :runtime, String
  property :poster_path, String
  property :trailer_id, String
  property :cast, String
  property :director, String
  property :music, String

  has n, :sessions
end

