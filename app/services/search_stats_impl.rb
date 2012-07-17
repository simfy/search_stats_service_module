class SetTermImpl
  def self.execute
    SearchStats.increment_search_term_score(type, term)
  end
end

class GetTermImpl
  def self.execute
    SearchStats.get_search_term_score(type, term)
  end
end

class GetTopTermsImpl
  def self.execute
    SearchStats.get_top_search_terms(type, limit)
  end
end

class GetTopTermsImpl
  def self.execute
    SearchStats.reset_all_search_stats()
  end
end