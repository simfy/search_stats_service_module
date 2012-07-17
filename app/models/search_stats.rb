class SearchStats

  class <<self

    # Public: Add/increment a counter for search terms stored in Redis.
    #
    # term - The search string to be added.
    # type - The usage type, e.g. :notfound.
    #
    # Examples
    #
    #   SearchStats.increment_search_term_score(:notfound, 'Justin Bieber')
    #   # => 1.0
    #
    # Returns the score for the given search term.
    def increment_search_term_score(type, term)
      return false if term.nil?
      R.zincrby(type, 1, term.chomp.downcase)
    end

    # Public: Retrieve the number of hits for a search term for a search type
    #
    # term - The search string to be retrieved.
    # type - The usage type, e.g. :notfound.
    #
    # Examples
    #
    #   SearchStats.get_search_term_score(:notfound, 'Justin Bieber')
    #   # => 1.0
    #
    # Returns the score for the given search term.
    def get_search_term_score(type, term)
      R.zscore(type, term.downcase)
    end

    # Public: Retrieve the ranked terms by type.
    #
    # type  - The usage type, e.g. :notfound.
    # limit - The number of terms to be returned.
    #
    # Examples
    #
    #   SearchStats.get_top_search_terms(:notfound, 2)
    #   # => [["justin bieber", 5.0], ["lady gaga", 3.0]]
    #
    # Returns an ordered array of terms with scores.
    def get_top_search_terms(type, limit)
      R.zrevrange(type, 0, limit-1, { withscores: true })
    end


    # Public: Reset the Redis store.
    #
    # Examples
    #
    #   SearchStats.reset_all_search_stats
    #   # => OK
    #
    # Returns OK.
    def reset_all_search_stats
      R.flushall
    end
  end
end