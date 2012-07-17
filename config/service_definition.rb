Hoth::Services.define do
 
  service :set_term do |type, term|
    returns :score
  end

  service :get_term do |type, term|
  	returns :score
  end

  service :get_top_terms do |type, limit|
  	returns :top_scores
  end

  service :reset_all do
  	returns :ok
  end
end