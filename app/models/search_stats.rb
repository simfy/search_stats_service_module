class SearchStats

  # Public: Add/increment a counter for search terms stored in Redis
  #
  # term - The search string to be added.
  # type - The usage type, e.g. "notfound"
  #
  # Examples
  #
  #   SearchStats.set_search_usage('Justin Bieber', 'search_terms')
  #   # => 1.0
  #
  # Returns the Redis record.
  def self.set_term(type, term)
    R.zincrby(type, 1, term.chomp.downcase)
  end

  # Retrieve the number of hits for a search term for a search type
  def self.get_term(type, term)
    R.zscore(type, term.downcase)
  end

  # Retrieve the ranked terms by type
  def self.get_top(type, limit)
    R.zrevrange(type, 0, limit-1, { withscores: true })
  end

  def self.reset_all
    R.flushall
  end

end