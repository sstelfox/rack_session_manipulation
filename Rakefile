require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  puts 'RSpec isn\'t available to the rake environment'
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.formatters = %w(simple offenses)
    task.fail_on_error = false
    task.options = %w(--format html --out doc/rubocop.html)
  end
rescue LoadError
  puts 'Rubocop isn\'t available to the rake environment'
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new(:docs)
rescue LoadError
  puts 'Yardoc isn\'t available to the rake environment'
end

task :default do
  Rake::Task[:docs].invoke     if Rake::Task.task_defined?(:docs)
  Rake::Task[:rubocop].invoke  if Rake::Task.task_defined?(:rubocop)
  Rake::Task[:spec].invoke     if Rake::Task.task_defined?(:spec)
end

task 'environment' do
  require 'rack_session_manipulation'
end

desc 'Run a console with the application loaded'
task :console => [:environment] do
  require 'pry'
  pry
end
