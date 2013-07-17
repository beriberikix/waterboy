require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'

get '/' do
  erb :index
end

get '/blue/up' do
  "BLUE UP"
end

get '/blue/down' do
  "BLUE DOWN"
end

get '/red/up' do
  "RED UP"
end

get '/red/down' do
  "RED DOWN"
end

get '/debugip' do
  "COOL"
end
