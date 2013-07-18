require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/goal'
require './models/match'

get '/' do
  @match = Match.current

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

get '/debugip' do
  "COOL"
end
