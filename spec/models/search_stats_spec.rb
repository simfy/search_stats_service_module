require 'spec_helper'

describe SearchStats do

  let(:store) { Redis.new }

  before(:each) do
    R.flushall
    5.times { SearchStats.set_term(:test, "justin bieber") }
    3.times { SearchStats.set_term(:test, "lady gaga") }
    3.times { SearchStats.set_term(:test, "nas") }
    3.times { SearchStats.set_term(:test, "cro") }
  end

  describe "#set_term" do
    it "should increment a search terms' score" do
      SearchStats.set_term(:test, "justin bieber").should == 6.0
      SearchStats.set_term(:test, "justin bieber").should == 7.0
    end
  end

  describe "#get_term" do
    it "should return the current score for a term" do
      SearchStats.get_term(:test, "Justin Bieber").should == 5.0
    end
  end

  describe "#get_top_terms" do
    it "should return the top 3 terms of a given set" do
      SearchStats.get_top(:test, 3).should be_an Array
      SearchStats.get_top(:test, 3).should == [["justin bieber", 5.0], ["nas", 3.0], ["lady gaga", 3.0]]
    end
  end

  describe "#reset_all" do
    it "should clear all terms and scores" do
      SearchStats.reset_all.should == "OK"
      SearchStats.get_top(:test, 3).should == []
    end
  end

end