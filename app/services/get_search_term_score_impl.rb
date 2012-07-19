class GetSearchTermScoreImpl
  def self.execute(type, term)
    SearchStats.get_search_term_score(type, term)
  end
end