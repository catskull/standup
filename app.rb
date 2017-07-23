# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'json'

class Event < ActiveRecord::Base
end

get "/" do
  content_type :json
  response['Access-Control-Allow-Origin'] = '*'
  @events = Event.all.group(:owner)
  @events.to_json
end

post "/" do
  params.delete("captures")
  unless params["status"].present?
    if params["standing"] == "true"
      params["status"] = "standing"
    else
      params["status"] = "sitting"
    end
  end

  event = Event.create(params)
  event.to_json
end
