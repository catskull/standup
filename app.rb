# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'json'

class User < ActiveRecord::Base
  has_many :events, dependent: :destroy

  def last_five_days_totals
    hash = {}
    7.times do |t|
      if (!['Saturday', 'Sunday'].include?((t-1).days.ago.strftime("%A")))
        hash[(t-1).days.ago.to_date.to_s] = 0
      end
    end
    self.events.where("ended_at > ?", 7.days.ago).each do |event|
      hash[event.ended_at.to_date.to_s] += event.elapsed_time_in_seconds
    end
    hash
  end
end

class Event < ActiveRecord::Base
  belongs_to :user

  # private
  def calculate_elapsed_time
    if (self.ended_at)
      (self.ended_at - self.created_at).to_i
    else
      nil
    end
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
  user = User.where(email: params["email"]).first

  params.delete("email")
  params.delete("captures")

  params["user_id"] = user.id

  if (user.events.last.present? && user.events.last.ended_at.nil?)
    event = user.events.last
    event.ended_at = DateTime.now
    event.save
    event.elapsed_time_in_seconds = event.calculate_elapsed_time
    event.save
  else
    event = Event.create(params)
  end
  event.to_json
end

get "/users" do
  response['Access-Control-Allow-Origin'] = '*'
  users = []
  User.all.each do |u|
    hash = {}
    hash["totals"] = u.last_five_days_totals
    hash["name"] = u.name
    hash["id"] = u.id
    if u.events.any?
      hash["standing"] = u.events.last.ended_at.nil?
    else
      hash["standing"] = nil
    end
    users.push(hash)
  end
  users.to_json
end

post "/users/create" do
  params.delete("captures")
  user = User.create(params)
  user.to_json
end
