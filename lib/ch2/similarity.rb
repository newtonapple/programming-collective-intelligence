# == Similarity is a set of untility methods that compares the closeness of sets of scores.
# Dir[File.dirname(__FILE__) + "/similarity/*.rb"].each { |file| require(file) }

require 'ruby-debug'
require File.dirname(__FILE__) + '/similarity/metrics'
require File.dirname(__FILE__) + '/similarity/recommendations'
require File.dirname(__FILE__) + '/similarity/preferences'
