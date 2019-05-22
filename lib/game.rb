class Game
  attr_reader :game_row, :home_team_id, :away_team_id, :away_goals, :home_goals

  def initialize(game_row)
    @game_row = game_row
    @home_team_id = game_row[:home_team_id]
    @home_goals = game_row[:home_goals]
    @away_team_id = game_row[:away_team_id]
    @away_goals = game_row[:away_goals]
  end
end
