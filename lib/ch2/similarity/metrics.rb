module Similarity
  module Metrics
    module ClassMethods
      # === Ecludiean Distance
      # * Ecludiean distance measures the similarity of two subjects by measuring the closeness of each of their preference scores.
      # * The heuristic is calculated by summing up the differences of two subjects' scores.
      # * Since we want a positive number we'll square those differences.
      # * Two subjects are more similar if their sum of score differences is smaller.
      #
      # ==== Formula:
      #     d = √( ∑(x-y)^2 )
      #
      # ==== Parmamters:
      # <tt>x, y</tt>:: {"item" => score}
      #
      # ==== Returns:
      # √( ∑(x-y)^2 )
      def ecludiean_distance( x, y )    
        common_items(x, y).inject(0) do |sum, item|
          # only count the scores if both subjects share something in common
          # i.e. they both rated the item
          sum += (x[item] - y[item]) ** 2
        end
      end


      # Since we want a higher score to represent more similiarity between the subjects, we'll simpliy take the inverse the ecludiean_distance. 
      # And, to prevent division by zero we'll add 1 to the denominator.
      # <em>Book Reference</em>:: <tt>sim_distance()</tt> in book.
      #
      # ==== Formula:
      #       1 / ( 1 + √( ∑(x-y)^2 ) )
      #
      # ==== Parmamters:
      # <tt>x, y</tt>:: {"item" => score}
      #
      # ==== Returns:
      # Distance similarity will always return a number b/w (0, 1]
      def distance_similarity( x, y )
        # note you don't need a root here, since we are only looking for inverse difference
        # as long as we are comparing everything to the same scale we're ok
        1 / ( 1 + ecludiean_distance(x, y) )
      end
      alias :sim_distance :distance_similarity

      # === Pearson Correlation Score
      # * Pearson Correlation Score is also known as the "best-fit line" heurestic.
      # * Pearson Correlation summarizes the linear relationships between two subjects.
      # * It corrects "grade inflation" e.g. someone who is a particularly harsh or generous critic.
      #
      # ==== Formula:
      #     r = ( ∑x∙y - ∑x∙∑y/n ) / √( (∑x^2 - (∑x)^2/n) ∙ (∑y^2 - (∑y)^2/n) )
      #
      # ==== Parmamters:
      # <tt>x, y</tt>:: {"item" => score}
      #
      # ==== Returns:
      # Pearson Score is between [-1, 1]:
      # 1. -1: implies rating/scores of x & y are complete opposite
      # 2.  1: implies x & y rated exactly the same
      # 3.  0: x & y not related
      def linear_similarity( x, y )
        common_items = common_items(x, y)
        return 0 if common_items.empty? # nothing is shared

        n = common_items.size.to_f
        xy_sum_of_products = x_sum = y_sum = x_sum_of_squared = y_sum_of_squared = 0

        common_items.each do |item| 
          x_score, y_score    = x[item], y[item]
          x_sum              += x_score
          y_sum              += y_score
          x_sum_of_squared   += (x_score ** 2)
          y_sum_of_squared   += (y_score ** 2)
          xy_sum_of_products += (x_score * y_score)
        end

        individual_variants = Math.sqrt( (x_sum_of_squared - x_sum ** 2 / n) * (y_sum_of_squared - y_sum ** 2 / n) ) 
        return 0 if individual_variants == 0 # prevent division by zero
        variant = (xy_sum_of_products - x_sum * y_sum / n)
        variant / individual_variants
      end
      alias :pearson_similarity :linear_similarity
      
      
        private 
          # returns common_times shared by x and y
          #--
          # NOTE: common_items can be found through generic traversal of the smaller set
          # for example:
          #   if x.size < y.size
          #   we can traverse x and generate stats for any item such that x[item] & y[item] exists
          # This could be faster when x.size and y.size is large
          def common_items(x, y)
            x.keys & y.keys
          end  
    end  # ClassMethods

    extend ClassMethods # make all ClassMethods Metrics' class methods as well.
  end  # Metrics
end # Similarity