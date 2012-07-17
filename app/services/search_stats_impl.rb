class IncrementSearchTermScoreImpl
  def self.execute
    SearchStats.increment_search_term_score(type, term)
  end
end

class GetSearchTermScoreImpl
  def self.execute
    SearchStats.get_search_term_score(type, term)
  end
end

class GetTopSearchTermsImpl
  def self.execute
    SearchStats.get_top_search_terms(type, limit)
  end
end

class ResetAllSearchStatsImpl
  def self.execute
    SearchStats.reset_all_search_stats()
  end
end