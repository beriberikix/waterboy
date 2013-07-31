require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'eventmachine'
require 'em-websocket'
require 'thin'

require './config/server'
require './config/environments'
require './models/goal'
require './models/match'

$channel = EM::Channel.new

EventMachine.run do
  class App < Sinatra::Base

    get '/' do
      @match = Match.current
      @matches = Match.all.order('created_at desc')

      erb :index
    end

    get '/blue/up' do
      Match.current.record_goal!(:blue)
      $channel.push "blue-up"

      "blue-up"
    end

    get '/blue/down' do
      Match.delete_goal!(:blue)
      $channel.push "blue-down"

      "blue-down"
    end

    get '/red/up' do
      Match.current.record_goal!(:red)
      $channel.push "red-up"

      "red-up"
    end

    get '/red/down' do
      Match.delete_goal!(:red)
      $channel.push "red-down"

      "red-down"
    end

    get '/match/new' do
      Match.create!
      $channel.push "new-match"

      "new-match"
    end

    get '/match/delete' do
      # Delete the current match
      Match.current.goals.destroy_all
      Match.current.destroy
      $channel.push "delete-match"

      "delete-match"
    end

    get '/checkin' do
      "COOL"
    end

    get '/debugip' do
      "COOL"
    end
  end

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 3002) do |ws|
    ws.onopen {
      sid = $channel.subscribe { |msg| ws.send msg }

      ws.onmessage { |msg|
        $channel.push "You sent: #{msg}"
      }

      ws.onclose {
        $channel.unsubscribe(sid)
      }
    }
  end

  Thin::Server.start App, '0.0.0.0', 3000
end
