require 'pry'
module SeasonStatistics
  def biggest_bust(season_id)
    most_improved = post_reg_difference(season_id).min do |win_a, win_b|
      win_a[1] <=> win_b[1]
    end
    @teams[most_improved[0].to_sym].team_name
  end

  def biggest_surprise(season_id)
    most_improved = post_reg_difference(season_id).max do |win_a, win_b|
      win_a[1] <=> win_b[1]
    end
    @teams[most_improved[0].to_sym].team_name
  end

  def most_accurate_team(season_id)
    games = all_games_by_season(season_id)
    team_data = accurate_team(games).max_by do |game|
      game[1][:goals]/game[1][:shots].to_f
    end
    @teams[team_data[0].to_sym].team_name
  end

  def least_accurate_team(season_id)
    games = all_games_by_season(season_id)
    team_data = accurate_team(games).min_by do |game|
      game[1][:goals]/game[1][:shots].to_f
    end
    @teams[team_data[0].to_sym].team_name
  end

  def winningest_coach(season_id)
    coach_win_percentage(season_id).max do |coach_win_a,coach_win_b|
      coach_win_a[1] <=> coach_win_b[1]
    end[0]
  end

  def worst_coach(season_id)
    coach_win_percentage(season_id).min do |coach_win_a,coach_win_b|
      coach_win_a[1] <=> coach_win_b[1]
    end[0]
  end

  def most_hits(season_id)
    team = hits_by_team(season_id).max do |hits_a, hits_b|
      hits_a[1] <=> hits_b[1]
    end
    @teams[team[0].to_sym].team_name
  end

  def fewest_hits(season_id)
    team = hits_by_team(season_id).min do |hits_a, hits_b|
      hits_a[1] <=> hits_b[1]
    end
    @teams[team[0].to_sym].team_name
  end

  def power_play_goal_percentage(season_id)
    game_teams = game_teams_by_season(season_id)
    power_goals = game_teams.sum {|game_team| game_team.power_play_goals}
    power_opps = game_teams.sum {|game_team| game_team.power_play_opportunities}
    (power_goals.to_f / power_opps).round(2)
  end
end
