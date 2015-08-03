require 'sinatra'
require 'lifx_toys'
require 'active_support/time'

TIMEZONE = "Melbourne"

REQUIRED_ENV_SETTINGS = %w[
                          HTTP_AUTH_USER
                          HTTP_AUTH_PASSWORD
                          LIFX_TOKEN
                          ]


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

def check_required_environment
  missing_env_vars = REQUIRED_ENV_SETTINGS.reject do |var|
    ENV[var]
  end
  raise "Some required ENV vars are missing: #{missing_env_vars.join(", ")}" unless missing_env_vars.empty?
end

check_required_environment
