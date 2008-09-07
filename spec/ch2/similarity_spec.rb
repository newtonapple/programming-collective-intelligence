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
  
end

describe Similarity, "ecludiean similarity" do
  include SimilaritySpecHelpers
  
  before :all do
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
  
  describe 'ecludiean distance similarity' do
    
    it 'should calculate correct sum of squared differences' do
      c1, c2 = @critics['Lisa Rose'], @critics['Gene Seymour']
      Similarity.ecludiean_distance( c1, c2 ).should == sum_of_squared_differences(c1,c2)
    end
  
    it 'should calculate ecludiean similarity as 1 / (1 + sum_of_squared_differences)' do
      c1, c2 = @critics['Lisa Rose'], @critics['Gene Seymour']
      Similarity.distance_similarity( c1, c2 ).should == ( 1 / ( 1 + sum_of_squared_differences(c1,c2) ) )
    end
    
  end
  
end