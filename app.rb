require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/goal'
require './models/match'

get '/' do
  @match = Match.current
  @matches = Match.all.order('created_at desc')

  erb :index
end

get '/blue/up' do
  Match.current.record_goal!(:blue)

  redirect "/"
end

get '/blue/down' do
  Match.delete_goal!(:blue)

  redirect "/"
end

get '/red/up' do
  Match.current.record_goal!(:red)

  redirect "/"
end

get '/red/down' do
  Match.delete_goal!(:red)

  redirect "/"
end

get '/match/new' do
  Match.create!

  redirect "/"
end

get '/match/delete' do
  Match.current.goals.destroy_all
  Match.current.destroy

  redirect "/"
end

get '/debugip' do
  "COOL"
end
