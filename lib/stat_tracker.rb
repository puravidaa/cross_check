#require './modules/game_statistics'
#require './modules/league_statistics'
require './modules/team_information'
require 'pry'

class StatTracker
  #include GameStatistics
  include TeamInformation
  #include LeagueStatistics

  attr_reader :games, :teams, :game_teams

  def initialize(games, teams, game_teams)
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def self.from_csv(locations)
    games = get_games(locations[:games])
    teams = get_teams(locations[:teams])
    game_teams = get_game_teams(locations[:game_teams])
    StatTracker.new(games, teams, game_teams)
  end

  def self.get_game_teams(path)
    game_teams = []
    CSV.foreach(path, headers: true, header_converters: CSV::HeaderConverters[:symbol]) do |row|
      game_teams << GameTeam.new(row)
    end
    game_teams
  end

  def self.get_teams(path)
    teams = {}
    CSV.foreach(path, headers: true, header_converters: CSV::HeaderConverters[:symbol]) do |row|
      teams[row[0].to_sym] = Team.new(row)
    end
    teams
  end

  def self.get_games(path)
    games = []
    CSV.foreach(path, headers: true, header_converters: CSV::HeaderConverters[:symbol]) do |row|
      games << Game.new(row)
    end
    games
  end
end
#binding.pry
