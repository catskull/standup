# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'json'

class User < ActiveRecord::Base
  has_many :events, dependent: :destroy
end

class Event < ActiveRecord::Base
  belongs_to :user

  before_save :set_owner

  private
  def set_owner
    self.owner = self.user.name
  end
end

get "/" do
  content_type :json
  response['Access-Control-Allow-Origin'] = '*'
  events = []
  User.all.each do |u|
    events.push(u.events.last)
  end
  events.to_json
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
