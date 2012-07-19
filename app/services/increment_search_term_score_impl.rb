class IncrementSearchTermScoreImpl
  def self.execute(type, term)
    SearchStats.increment_search_term_score(type, term)
  end
end