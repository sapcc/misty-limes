require 'rake/testtask'

task :default => [:test]

desc "Run limes tests"
task :limes do
  Rake::TestTask.new do |t|
    t.name = 'limes'
    t.libs << "test/limes"
    t.test_files = FileList['test/limes/*_test.rb']
    t.verbose = true
  end
end

