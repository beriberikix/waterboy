require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'eventmachine'
require 'em-websocket'
require 'thin'
require 'json'

require './config/server'
require './config/environments'
require './models/goal'
require './models/match'
require './models/player'

$channel = EM::Channel.new

EventMachine.run do
  class App < Sinatra::Base

    # Push the score to the client after each request
    ['/*'].each do |path|
      after path do
        $channel.push ({ score: score_string }).to_json
      end
    end

    # Create a simple string containing the score
    def score_string
      blue_goals = Match.current.goals_by("blue").count
      red_goals = Match.current.goals_by("red").count

      "b#{blue_goals}-r#{red_goals}"
    end

    get '/' do
      @match = Match.current
      @matches = Match.all.order('created_at desc')

      erb :index
    end

    get '/blue/up' do
      Match.current.record_goal!(:blue)

      "blue-up"
    end

    get '/blue/down' do
      Match.delete_goal!(:blue)

      "blue-down"
    end

    get '/red/up' do
      Match.current.record_goal!(:red)

      "red-up"
    end

    get '/red/down' do
      Match.delete_goal!(:red)

      "red-down"
    end

    get '/match/new' do
      Match.create!
      $channel.push ({ message: "new-match" }).to_json
      $channel.push ({ match: Match.current }).to_json

      "new-match"
    end

    get '/match/delete' do
      # Delete the current match
      Match.current.goals.destroy_all
      Match.current.destroy
      $channel.push ({ message: "delete-match" }).to_json
      $channel.push ({ match: Match.current }).to_json

      "delete-match"
    end

    get '/players/:id' do
      Player.find(params[:id]).to_json
    end

    get '/checkin' do
      player = Player.from_params(params)
      team = params['team'].downcase.to_sym
      pos = params['position'].to_i

      Match.current.set_player!(team, pos, player)
      $channel.push ({ match: Match.current }).to_json

      "COOL"
    end

    get '/debugip' do
      "COOL"
    end
  end

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 3002) do |ws|
    ws.onopen {
      sid = $channel.subscribe { |msg| ws.send msg }

      $channel.push ({ match: Match.current }).to_json

      ws.onmessage { |msg|
        $channel.push "You sent: #{msg}"
      }

      ws.onclose {
        $channel.unsubscribe(sid)
      }
    }
  end

  Thin::Server.start App, '0.0.0.0', 3001
end
