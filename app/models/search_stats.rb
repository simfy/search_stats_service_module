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
  class <<self
    def increment_search_term_score(type, term)
      R.zincrby(type, 1, term.chomp.downcase)
    end

    # Retrieve the number of hits for a search term for a search type
    def get_search_term_score(type, term)
      R.zscore(type, term.downcase)
    end

    # Retrieve the ranked terms by type
    def get_top_search_terms(type, limit)
      R.zrevrange(type, 0, limit-1, { withscores: true })
    end

    def reset_all_search_stats
      R.flushall
    end
  end
end