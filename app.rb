require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../models', __FILE__)

require 'json'

## need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/movies.db")

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

class Session
  include DataMapper::Resource

  property :session_id, Serial
  property :movie_id, Integer
  property :state, String
  property :city, String
  property :postcode, String
  property :suburb, String
  property :cinema, String
  property :start_date, Date
  property :end_date, Date
  property :booking_url, String
  property :session_times, Text

  belongs_to :movie
end

#Dir['models/**/*'].sort.each { |file| require file }

## Perform basic sanity checks and initialize all relationships
## Call this when you've defined all your models
DataMapper.finalize
#
## automatically create the post table
Movie.auto_upgrade!
Session.auto_upgrade!

# binding.pry # use to debug

def get_movie_data state=""
  movie_data = []

  if state != ""
    @sessions = Session.all(:fields => [:movie_id], :unique => true, :state => state)
  else
    @sessions = Session.all(:fields => [:movie_id], :unique => true)
  end

  @sessions.each do |session|
    @movie = Movie.first(:movie_id => session.movie_id)
    if state != ""
      @movie_session = Session.all(:state => state).all(:movie_id => @movie.movie_id)
    else
      @movie_session = Session.all(:movie_id => @movie.movie_id)
    end
    @payload = { movie_details: @movie, sessions: @movie_session }
    movie_data.push @payload
  end

  return movie_data
end

get '/movies' do
  redirect '/movies/'
end

get '/movies/*' do
  response["Access-Control-Allow-Origin"] = "*"
  state = params[:splat].first.upcase

  get_movie_data( state ).to_json
end

