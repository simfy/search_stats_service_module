class ResetAllSearchStatsImpl
  def self.execute()
    SearchStats.reset_all_search_stats()
  end
end