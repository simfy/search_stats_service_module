class GetTopSearchTermsImpl
  def self.execute(type, limit)
    SearchStats.get_top_search_terms(type, limit)
  end
end