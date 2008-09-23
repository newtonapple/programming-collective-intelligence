module Similarity
  module Recommendations
    # ==== Parmamters:
    # <tt>preferences</tt>:: {'subject1' => {"item1"=>score1, "item2"=>score12},... }
    # <tt>subject</tt>:: the name of the subject that you want to compare others with.
    # <tt>n</tt>:: the number of top matches to return (default to 5)
    # <tt>similarity_metric</tt>:: the Similarity::Metrics method to use.
    # 
    # ==== Returns:
    # An array of arrays containing top n subjects and their similarity scores
    #  [ ['subject2', 0.923], ['subject2', 0.623], ... ]
    def self.top_subject_matches(preferences, subject, n=5, similarity_metric='pearson_similarity')
      sort_and_trim! subject_matches(preferences, subject, similarity_metric), n
    end

    def self.top_item_matches(preferences, subject, n=5, similarity_metric='pearson_similarity')
      sort_and_trim! item_matches(preferences, subject, similarity_metric), n
    end


    def self.subject_matches(preferences, subject, similarity_metric='pearson_similarity')
      results             = []
      subject_item_scores = preferences[subject]
      
      preferences.each do |other_subject, other_item_scores|
        if other_subject != subject # compute similarity score if not the same subjects
          results << [other_subject, Metrics.send(similarity_metric, subject_item_scores, other_item_scores)]
        end
      end
      results
    end

    def self.item_matches(preferences, subject, similarity_metric='pearson_similarity')
      sum_of_weighted_item_scores = Hash.new(0)  # TODO: combine the two hashes into one
      sum_of_sim_scores           = Hash.new(0)
      subject_item_scores         = preferences[subject]

      similarity_scores = subject_matches(preferences, subject, similarity_metric)
      similarity_scores.each do |other_subject, sim_score|
        next if sim_score < 0 # skip negatives
        disjoint_items(preferences[other_subject], subject_item_scores).each do |item| # any items that don't belong to subject
          item_score                         = preferences[other_subject][item]
          sum_of_weighted_item_scores[item] += ( sim_score * item_score )
          sum_of_sim_scores[item]           += sim_score 
        end
      end

      sum_of_weighted_item_scores.collect do |item, weighted_item_score|
        [ item, weighted_item_score / sum_of_sim_scores[item] ]  # normalize weight so most reviewed items will not dominate
      end
    end

    class << self 
      alias :top_matches :top_subject_matches 
      alias :get_recommendations :top_item_matches
    end

    private 
      def self.disjoint_items(x,y)
        x.keys - y.keys
      end

      def self.sort_and_trim!(array, n)
        array.sort!{ |x, y| y.last <=> x.last }
        truncate_length = array.length - n
        array.slice!(n, truncate_length) if truncate_length >= 0
        array
      end
  end
end