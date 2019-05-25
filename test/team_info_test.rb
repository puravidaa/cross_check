require './test/test_helper'

class TeamInfoTest < Minitest::Test
  def setup
    @game_path = './data/game_tay.csv'
    @team_path = './data/team_tay.csv'
    @game_teams_path = './data/game_teams_stats_dummy.csv'
    @locations = { games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path }
    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_find_games_by_team_id
    expected = ["2012030221", "2012030222", "2012030223",
                "2012030224", "2012030225"]
    actual = @stat_tracker.find_games_by_team_id("3").map{|game| game.game_id}
    assert_equal expected, actual
  end

  def test_games_by_season
    actual = @stat_tracker.games_by_season("6")
    assert actual["20122013"].all?{|game| game.season == "20122013"}
    assert actual["20172018"].all?{|game| game.season == "20172018"}
  end

  def test_won_at_home
    game_1 = @stat_tracker.games.find{|game| game.game_id == "2012030221"}
    assert @stat_tracker.won_at_home?("6",game_1)
    game_3 = @stat_tracker.games.find{|game| game.game_id == "2012030223"}
    refute @stat_tracker.won_at_home?("3",game_3)
  end

  def test_won_away
    game_1 = @stat_tracker.games.first
    refute @stat_tracker.won_away?("3",game_1)
    game_3 = @stat_tracker.games[2]
    assert @stat_tracker.won_away?("6",game_3)
  end

  def test_win_percent_by_season
    expected = {"20122013" => 0.8, "20172018" => 0.2}
    assert_equal expected, @stat_tracker.win_percent_by_season("6")
  end

  def test_percent_wins
    games_6 = @stat_tracker.find_games_by_team_id("6")
    assert_equal 0.5, @stat_tracker.percent_wins("6",games_6)
  end

  def test_extreme_scores
    game_1 = @stat_tracker.games.first
    assert_equal 3, @stat_tracker.extreme_scores("6",game_1)
    assert_equal 2, @stat_tracker.extreme_scores("3",game_1)
  end

  def test_win_percent_by_team_hash
    expected = {"Lightning" => 0.2, "Rangers" => 0.8}
    actual = @stat_tracker.win_percent_by_team_hash("6",@stat_tracker.games)
    assert_equal expected, actual
  end
end
