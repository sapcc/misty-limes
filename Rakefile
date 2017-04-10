require 'dotenv/tasks'
require 'rake/testtask'

desc "Run limes tests"
task :limes => [:dotenv] do
  Rake::TestTask.new do |t|
    t.name = 'limes'
    t.libs << "test/limes"
    t.test_files = FileList['test/limes/*_test.rb']
    t.verbose = true
  end
end

