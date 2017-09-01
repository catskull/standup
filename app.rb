# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'json'
require 'rufus-scheduler'

configure do
  scheduler = Rufus::Scheduler.new
  set :scheduler, scheduler

  # every minute on weekdays
  # scheduler.every '1s' do
  #   Job.award_minutes
  # end

  # every 1:00am generate report records
  # scheduler.cron '0 1 * * *' do
  #   Job.create_daily_reports
  # end
end

module Job
  def self.award_minutes
    puts 'Awarding minutes to worthy users'
    User.where('standing = ?', 1)
      .where("start_time > ?", Time.now)
      .where("end_time < ?", Time.now)
      .each { |u| u.update_attributes(minutes_today: u.minutes_today + 1) }
  end

  def self.create_daily_reports
    puts 'Generating reports'
    User.all.each do |u|
      report = DailyReport.new
      report.user = u
      report.minutes_standing = u.minutes_today
      report.date = Date.yesterday
      report.save!
    end
  end
end

class User < ActiveRecord::Base
  has_many :events, dependent: :destroy
  has_many :daily_reports, dependent: :destroy

  def effective_elapsed_minutes datetime_start, datetime_end
    datetime_end = DateTime.now if datetime_end.nil?
    days_elapsed = (datetime_end - datetime_start).to_f
    minutes_elapsed = days_elapsed*24*60

    # subtract the first night's elapsed minutes
    if datetime_start.hour > self.end_time
      minutes_elapsed = minutes_elapsed - ((24-datetime_start.hour)*60) - (self.start_time*60)
    else
      minutes_elapsed = minutes_elapsed - (8*60)
    end
    # subtract the last night's elapsed minutes
    if days_elapsed > 1
      if datetime_end.hour > self.end_time
        total_elapsed = total_elapsed - ((end_time.hour - self.user.end_time)*60)
      else
        total_elapsed = total_elapsed - (8*60)
      end  
    end
    # subtract the minutes at nights between first night and last night
    if days_elapsed > 2
      total_elapsed = total_elapsed - ((days_elapsed-2)*8*60)
    end
    total_elapsed 

  end

  def is_standing
    current_event.present? && Time.now < self.end_time
  end

  def current_event
    if self.events.present? && self.events.last.ended_at.nil?
      self.events.last
    end
  end

  def ended_events
    self.events.where('ended_at is not null')
  end

  def minutes_since datetime
    minutes = self.events.
      where('created_at > ? and ended_at is not null', datetime).
      sum{ |e| e.elapsed_minutes }

    self.events.where('created_at < ? and ended_at > ? and ended_at is not null', datetime).
      sum{ |e| e.elapsed_minutes - ((datetime - e.created_at)) }

  end

  def minutes_this_week
    mins = 0
    if current_event.present?
      
    end
    self.events.
      where('ended_at is null or created_at is > ? ', Time.today.at_beginning_of_week)
  end

  def minutes_today
    self.events_since(Time.today.at_beginning_of_day)
      .sum

  end


  def minutes_this_month
    self.minutes_today + daily_reports
      .select{|r| r.date > Date.today.at_beginning_of_month }
      .sum{ |r| r.minutes_standing }
  end

  def minutes_this_year
    self.minutes_today + daily_reports
      .select{|r| r.date > Date.today.at_beginning_of_year }
      .sum{ |r| r.minutes_standing }
  end

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

  def elapsed_minutes
    end_time = self.ended_at || Time.now
    total_elapsed = end_time - self.created_at / 60
    days_elapsed = (total_elapsed / (60*24)).to_i

    # subtract the first night's elapsed minutes
    if self.created_at.hour > self.user.end_time
      total_elapsed = total_elapsed - ((24-self.created_at.hour)*60) - (self.user.start_time*60)
    else
      total_elapsed = total_elapsed - (8*60)
    end
    # subtract the last night's elapsed minutes
    if days_elapsed > 1 
      if end_time.hour > self.user.end_time
        total_elapsed = total_elapsed - ((end_time.hour - self.user.end_time)*60)
      else
        total_elapsed = total_elapsed - (8*60)
      end  
    end
    # subtract the minutes at nights between first night and last night
    if days_elapsed > 2
      total_elapsed = total_elapsed - ((days_elapsed-2)*8*60)
    end
    total_elapsed    
  end

  # private
  def calculate_elapsed_time
    if (self.ended_at)
      (self.ended_at - self.created_at).to_i
    else
      nil
    end
  end
end

class DailyReport < ActiveRecord::Base
  belongs_to :user


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
      hash["timestamp"] = u.events.last.updated_at
    else
      hash["standing"] = nil
      hash["timestamp"] = nil
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

