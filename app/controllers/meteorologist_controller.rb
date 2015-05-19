require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================

    #This code gets the geographic coordinates from google api
    url_coords="http://maps.googleapis.com/maps/api/geocode/json?address="+url_safe_street_address

    parsed_coords=JSON.parse(open(url_coords).read)

    @latitude = parsed_coords["results"][0]["geometry"]["location"]["lat"]

    @longitude = parsed_coords["results"][0]["geometry"]["location"]["lng"]

    #this code uses the coordinates to get the weather from dark sky

    api_key="2e74bd0d672a94bfda20a97c14cb3bb0"

    url_weather="https://api.forecast.io/forecast/"+api_key+"/"+@latitude.to_s+","+@longitude.to_s

    parsed_weather=JSON.parse(open(url_weather).read)

    @current_temperature = parsed_weather["currently"]["temperature"]

    @current_summary = parsed_weather["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_weather["hourly"]["data"][1]["summary"]

    @summary_of_next_several_hours = parsed_weather["hourly"]["summary"]

    @summary_of_next_several_days = parsed_weather["daily"]["summary"]

    render("street_to_weather.html.erb")
  end
end
