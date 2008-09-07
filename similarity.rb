module Similarity
  
  # subject1 => {"item" => score}
  # sum ( (Xi - Yi)^2 ) => sum of squared differences
  def self.ecludiean_distance subject1, subject2
    subject1.keys.inject(0) do |sum, item|
      sum += (subject1[item] - subject2[item]) ** 2  if subject2[item]
    end
  end
  
  
  # distance similarity will always return a number b/w (0, 1]
  def self.distance_similarity subject1, subject2
    # note you don't need a root here, since we are only looking for inverse difference
    # as long as we are comparing everything to the same scale we're ok
    1 / ( 1 + ecludiean_distance(subject1, subject2) )
  end
end