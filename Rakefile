require 'rake'
require 'rake/rdoctask'

namespace :rdoc do
  Rake::RDocTask.new(:build) do |rd|
     rd.main = "README.doc"
     rd.rdoc_dir = 'doc'
     rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
     rd.options += ['--all', '-c utf8']
  end
end

