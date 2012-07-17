class SetTermImpl
  def self.execute
    SearchStats.get_term(type, term)
  end
end

class GetTermImpl
  def self.execute
    SearchStats.get_term(type, term)
  end
end

class GetTopTermsImpl
  def self.execute
    SearchStats.get_top_terms(type, limit)
  end
end

class GetTopTermsImpl
  def self.execute
    SearchStats.reset_all()
  end
end