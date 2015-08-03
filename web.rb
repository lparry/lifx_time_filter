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
put '/turn/:state/lights_if_after/:time' do |state, specified_time|
  return '' unless state_valid?(state)
  if current_time_is_after(specified_time)
    lights.set_power_state state
  end
  ''
end

put '/turn/:state/lights_if_before/:time' do |state, specified_time|
  return '' unless state_valid?(state)
  if current_time_is_before(specified_time)
    lights.set_power_state state
  end
  ''
end

put '/turn/:state/lights_if_between/:time1/and/:time2' do |state, time1, time2|
  return '' unless state_valid?(state)
  if current_time_is_between(time1, time2)
    lights.set_power_state state
  end
  ''
end

def lights
  LifxToys::HttpApi.with_default_selector("all")
end

def time_zone
  ActiveSupport::TimeZone.new(TIMEZONE)
end

def current_time_is_after(time)
  time_zone.now > time_zone.parse(time)
end

def current_time_is_before(time)
  time_zone.now < time_zone.parse(time)
end

def current_time_is_between(time1, time2)
  _time1 = time_zone.parse(time1)
  _time2 = time_zone.parse(time2)

  # if the time period crosses midnight
  if _time2 < _time1
    _time2 += 1.day
  end
  (time_zone.now > _time1) && (time_zone.now < _time2)
end

def state_valid?(state)
  %w[on off].include? state
end

def check_required_environment
  missing_env_vars = REQUIRED_ENV_SETTINGS.reject do |var|
    ENV[var]
  end
  raise "Some required ENV vars are missing: #{missing_env_vars.join(", ")}" unless missing_env_vars.empty?
end

check_required_environment
