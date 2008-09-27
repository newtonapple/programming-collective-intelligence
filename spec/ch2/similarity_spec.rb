require File.dirname(__FILE__) + '/../spec_helper'
require 'ch2/similarity'


module SimilaritySpecHelpers
  
  def sum_of_squared_differences c1, c2
    shared_items = c1.keys & c2.keys
    differences = shared_items.map{ |item| c1[item] - c2[item] }
    squared_differences = differences.map{|diff| diff ** 2 }
    sum = 0
    squared_differences.each{ |sq_diff| sum += sq_diff }
    sum
  end
    
    
  class PreferencesHashMatcher
    def initialize(hash)
      @hash = hash
    end
    
    def matches?(preferences)
      @preferences = preferences
      @preferences.each do |k1, v1|
        v1.each do |k2, v2|
          return false if @hash[k1][k2] != v2
        end
      end
      true 
    end
    
    def failure_message
      "expected #{@preferences.inspect} == #{@critics.inspect}"
    end
  end

  def have_hash_content(hash)
    PreferencesHashMatcher.new(hash)
  end
    
end

describe Similarity do
  include SimilaritySpecHelpers

  before :all do
    # these are critics from the book
    @critics = {
      "Lisa Rose"        => { 'Lady in the Water'=>2.5, 'Snakes on a Plane'=>3.5, 'Just My Luck'=>3.0, 'Superman Returns'=>3.5, 'You, Me and Dupree'=>2.5, 'The Night Listener'=>3.0 },
      "Gene Seymour"     => { 'Lady in the Water'=>3.0, 'Snakes on a Plane'=>3.5, 'Just My Luck'=>1.5, 'Superman Returns'=>5.0, 'You, Me and Dupree'=>3.5, 'The Night Listener'=>3.0 },
      "Michael Phillips" => { 'Lady in the Water'=>2.5, 'Snakes on a Plane'=>3.0, 'Superman Returns'=>3.5, 'The Night Listener'=>4.0 },
      "Claudia Puig"     => { 'Snakes on a Plane'=>3.5, 'Just My Luck'=>3.0, 'Superman Returns'=>4.0, 'You, Me and Dupree'=>2.5, 'The Night Listener'=>4.5 },
      "Mick LaSalle"     => { 'Lady in the Water'=>3.0, 'Snakes on a Plane'=>4.0, 'Just My Luck'=>2.0, 'Superman Returns'=>3.0, 'You, Me and Dupree'=>2.0, 'The Night Listener'=>3.0 },
      "Jack Matthews"    => { 'Lady in the Water'=>3.0, 'Snakes on a Plane'=>4.0, 'Superman Returns'=>5.0, 'You, Me and Dupree'=>3.5, 'The Night Listener'=>3.0 },
      "Toby"             => { 'Snakes on a Plane'=>4.5, 'Superman Returns'=>4.0, 'You, Me and Dupree'=>1.0 }
    }
  end
  
  describe Similarity::Metrics do 
  
    describe 'ecludiean distance similarity' do
      it 'calculates correct sum of squared differences' do
        c1, c2 = @critics['Lisa Rose'], @critics['Gene Seymour']
        Similarity::Metrics.ecludiean_distance( c1, c2 ).should == sum_of_squared_differences(c1,c2)
      end
  
      it 'calculates ecludiean similarity as 1 / (1 + sum_of_squared_differences)' do
        c1, c2 = @critics['Lisa Rose'], @critics['Gene Seymour']
        Similarity::Metrics.sim_distance( c1, c2 ).should == ( 1 / ( 1 + sum_of_squared_differences(c1,c2) ) )
      end
    end
    
  end
  
  describe 'top_matches' do
    it 'ranks top similar subjects / critics' do
      top_matches = Similarity::Recommendations.top_matches(@critics, 'Toby', 3)
      top_matches.size.should == 3
      top_matches.map{|match| match.first}.should == ['Lisa Rose', 'Mick LaSalle', 'Claudia Puig'] # same as the book
    end
    
    it 'returns maximum items when n > maximum size of critics - 1 (excluding self)' do
      top_matches = Similarity::Recommendations.top_matches(@critics, 'Toby', 100)
      top_matches.size.should == @critics.size - 1
    end
  end
  
  describe 'get_recommendations' do
    it 'finds top recommened items' do
      recommended_items = Similarity::Recommendations.top_item_matches( @critics, 'Toby') 
      recommended_items.map{|recommeded| recommeded.first}.should == [ 'The Night Listener', 'Lady in the Water', 'Just My Luck']
    end
    
    it 'finds top recommened items' do
      recommended_items = Similarity::Recommendations.get_recommendations( @critics, 'Toby', 2) 
      recommended_items.map{|recommeded| recommeded.first}.should == [ 'The Night Listener', 'Lady in the Water']
    end
  end
  
  describe Similarity::Preferences do
    
    before :each do
      @preferences = Similarity::Preferences.new( @critics )
    end
    
    it 'has the same content as initial hash' do
      @preferences.should have_hash_content(@critics)
    end
    
    it 'ranks top similar subjects' do
      top_matches = @preferences.top_subject_matches('Toby', 3)
      top_matches.size.should == 3
      top_matches.map{|match| match.first}.should == ['Lisa Rose', 'Mick LaSalle', 'Claudia Puig']
    end
    
    it 'can transpose subjects and items' do
      hash = { :A => {:a=>1, :b=>2}, :B => {:b=>3, :c=>4 }, :C => {:c=>5, :a=>6}}
      prev = Similarity::Preferences.new hash
      expected_hash = {:a => {:A=>1, :C=>6}, :b => {:A=>2, :B=>3}, :c=>{:B=>4, :C=>5}}
      prev.transpose.should have_hash_content(expected_hash)
    end
  end
  
end