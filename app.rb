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

get "/events" do
  content_type :json
  response['Access-Control-Allow-Origin'] = '*'
  events = []
  User.all.each do |u|
    events.push(u.events.last)
  end
  events.to_json
end

post "/events/create" do
  puts params

  params.delete("captures")
  unless params["status"].present?
    if params["standing"] == "true"
      params["status"] = "standing"
    else
      params["status"] = "sitting"
    end
  end

  params["user_id"] = User.where(email: params["email"]).first.id
  params.delete("email")

  event = Event.create(params)
  event.to_json
end

get "/users" do
  User.all.to_json
end

post "/users/create" do
  params.delete("captures")
  user = User.create(params)
  user.to_json
end
