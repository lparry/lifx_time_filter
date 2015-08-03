require 'sinatra'
require 'lifx_toys'
require 'active_support/time'

TIMEZONE = "Melbourne"

# :time is in the format "6PM" or "6:15PM"
put '/turn_on_lights_if_after/:time' do |specified_time|
  if time_zone.now > time_zone.parse(specified_time)
    api.set_power_state "on"
  end
end

def lifx_api
  LifxToys::HttpApi.with_default_selector("all")
end

def time_zone
  ActiveSupport::TimeZone.new(TIMEZONE)
end

