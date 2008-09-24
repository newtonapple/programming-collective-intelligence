module Similarity
  
  class Preferences < Hash
    extend Metrics::ClassMethods
    extend Recommendations::ClassMethods
    
    def initialize(hash)
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
      klass.top_subject_matches(self, subject, n, similarity_metric)
    end
    
    def top_item_matches(subject, n=5, similarity_metric='pearson_similarity')
      klass.top_item_matches(self, subject, n, similarity_metric)
    end
    
    private 
      def klass
        @klass ||= self.class
      end
  end
  
end