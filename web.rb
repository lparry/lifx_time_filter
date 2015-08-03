require 'sinatra'
require 'lifx_toys'
require 'active_support/time'

TIMEZONE = "Melbourne"

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == ENV['HTTP_AUTH_USER'] and password == ENV['HTTP_AUTH_PASSWORD']
end

# :time is in the format "6PM" or "6:15PM"
put '/turn_on_lights_if_after/:time' do |specified_time|
  if time_zone.now > time_zone.parse(specified_time)
    lights.set_power_state "on"
  end
  ""
end

def lights
  LifxToys::HttpApi.with_default_selector("all")
end

def time_zone
  ActiveSupport::TimeZone.new(TIMEZONE)
end

