module Similarity
  
  class Preferences < Hash
    
    def initialize(hash=nil)
      replace hash if hash.is_a? Hash 
    end

    #--
    # %w{ top_subject_matches top_item_matches }.each do |method|
    #   code = %Q{
    #     def #{method}(subject, n=5, similarity_metric='pearson_similarity')
    #       klass.#{method}(self, subject, n, similarity_metric)
    #     end
    #   }
    #   self.class_eval( code, __FILE__, __LINE__ )
    # end
    
    def top_subject_matches(subject, n=5, similarity_metric='pearson_similarity')
      Recommendations.top_subject_matches(self, subject, n, similarity_metric)
    end
    
    def top_item_matches(subject, n=5, similarity_metric='pearson_similarity')
      Recommendations.top_item_matches(self, subject, n, similarity_metric)
    end
    
    # Transpose subjects and items
    # ==== Examples:
    #  prev = Preference.new( { :subject1 => {:item1 => 2.4, :item2 => 3}, subject2 => {item1 => 2.5, item3 => 1.2}  } )
    #  prve.transpose # =>  { :item1 => {:subject1 => 2.4, :subject2 => 2.5}, :item2 => {:subject1 => 3}, :item3 => {:subject2 => 1.2}   }
    def transpose
      prev = Hash.new { |hash, key| hash[key] = Hash.new }
      each do |subject, item_scores|
        item_scores.each do |item, item_score|
          prev[item][subject] = item_score
        end
      end
      self.class.new prev
    end
    
    
    def transpose!
      replace transpose
    end
  end
  
end