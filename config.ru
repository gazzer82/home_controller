require 'data_mapper'
require 'dashing'

configure do
  # The auth token used by external clients to get API access to the
  # dashing widgets.
  set :auth_token, ENV["DASHING_AUTH_TOKEN"]


  # Restore the event history on load
  savedHistory = Setting.get('history')
  if savedHistory
    set :history, JSON.parse(savedHistory.value)
  end

  # Upong exiting, write the event history to persistent storage
  at_exit do
    savedHistory = Setting.first_or_create(:name => 'history')
    savedHistory.value = JSON.generate(settings.history)
    savedHistory.save
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application