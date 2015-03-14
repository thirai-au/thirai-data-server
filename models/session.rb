class Session
  include DataMapper::Resource

  property :session_id, Serial
  property :movie_id, String
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

