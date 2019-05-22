module LeagueStatistics
  def count_of_teams
    @teams.size
  end

  def total_goals(home=true, away=true)
    @games.inject({}) do |hash, game|
      if away
        hash[game.away_team_id.to_sym] ||= 0
        hash[game.away_team_id.to_sym] += game.away_goals.to_i
      end
      if home
        hash[game.home_team_id.to_sym] ||= 0
        hash[game.home_team_id.to_sym] += game.home_goals.to_i
      end
      hash
    end
  end

  def total_games(home=true, away=true)
    @games.inject({}) do |hash, game|
      if away
        hash[game.away_team_id.to_sym] ||= 0
        hash[game.away_team_id.to_sym] += 1
      end
      if home
        hash[game.home_team_id.to_sym] ||= 0
        hash[game.home_team_id.to_sym] += 1
      end
      hash
    end
  end

  def average_score(home = true, away = true)
    @teams.inject({}) do |hash, team|
      if total_goals[team[0]].nil?
        hash
      else
        goals = total_goals(home, away)[team[0]]
        games = total_games(home, away)[team[0]]
        hash[team[0]] = goals / games.to_f
      end
      hash
    end
  end

  def best_offense
    @teams[average_score.max_by { |k,v| v }.first].team_name
  end

  def worst_offense
    @teams[average_score.min_by { |k,v| v }.first].team_name
  end

  def total_goals_allowed
    @games.inject({}) do |hash, game|
      hash[game.away_team_id.to_sym] ||= 0
      hash[game.away_team_id.to_sym] += game.home_goals.to_i
      hash[game.home_team_id.to_sym] ||= 0
      hash[game.home_team_id.to_sym] += game.away_goals.to_i
      hash
    end
  end

  def average_goals_allowed
    @teams.inject({}) do |hash, team|
      if total_goals[team[0]].nil?
        hash
      else
        hash[team[0]] = total_goals_allowed[team[0]] / total_games[team[0]].to_f
      end
      hash
    end
  end

  def best_defense
    @teams[average_goals_allowed.min_by { |k,v| v }.first].team_name
  end

  def worst_defense
    @teams[average_goals_allowed.max_by { |k,v| v }.first].team_name
  end

  def highest_scoring_visitor
    @teams[average_score(false, true).max_by { |k,v| v }.first].team_name
  end

  def lowest_scoring_visitor
    @teams[average_score(false, true).min_by { |k,v| v }.first].team_name
  end

  def highest_scoring_home_team
    @teams[average_score(true, false).max_by { |k,v| v }.first].team_name
  end

  def lowest_scoring_home_team
    @teams[average_score(true, false).min_by { |k,v| v }.first].team_name
  end

  def total_wins
    @games.inject({}) do |hash, game|
      if game.away_goals > game.home_goals
        hash[game.away_team_id.to_sym] ||= 0
        hash[game.away_team_id.to_sym] += 1
      elsif game.away_goals < game.home_goals
        hash[game.home_team_id.to_sym] ||= 0
        hash[game.home_team_id.to_sym] += 1
      end
      hash
    end
  end

  def winningest_team
    @teams[total_wins.max_by { |k,v| v }.first].team_name
  end

  
end
