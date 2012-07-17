Hoth::Services.define do
 
  service :increment_search_term_score do |type, term|
    returns :score
  end

  service :get_search_term_score do |type, term|
  	returns :score
  end

  service :get_top_search_terms do |type, limit|
  	returns :top_scores
  end

  service :reset_all_search_stats do
  	returns :ok
  end
end