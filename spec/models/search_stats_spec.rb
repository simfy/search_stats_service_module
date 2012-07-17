require 'spec_helper'

describe SearchStats do

  let(:store) { Redis.new }

  before(:each) do
    R.flushall
    5.times { SearchStats.increment_search_term_score(:test, "justin bieber") }
    3.times { SearchStats.increment_search_term_score(:test, "lady gaga") }
    3.times { SearchStats.increment_search_term_score(:test, "nas") }
    3.times { SearchStats.increment_search_term_score(:test, "cro") }
  end

  describe "#increment_search_term_score" do
    it "should increment a search terms' score" do
      SearchStats.increment_search_term_score(:test, "justin bieber").should == 6.0
      SearchStats.increment_search_term_score(:test, "justin bieber").should == 7.0
    end

    it "should ignore nil requests" do
      SearchStats.increment_search_term_score(:test, nil).should be_false
    end
  end

  describe "#get_search_term_score" do
    it "should return the current score for a term" do
      SearchStats.get_search_term_score(:test, "Justin Bieber").should == 5.0
    end
  end

  describe "#get_top_search_terms" do
    it "should return the top 3 terms of a given set" do
      SearchStats.get_top_search_terms(:test, 3).should be_an Array
      SearchStats.get_top_search_terms(:test, 3).should == [["justin bieber", 5.0], ["nas", 3.0], ["lady gaga", 3.0]]
    end
  end

  describe "#reset_all_search_stats" do
    it "should clear all terms and scores" do
      SearchStats.reset_all_search_stats.should == "OK"
      SearchStats.get_top_search_terms(:test, 3).should == []
    end
  end

end