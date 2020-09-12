# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

#!/usr/bin/env rake
# require 'bundler/gem_tasks'
# require 'engine_cart/rake_task'
# require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# RSpec::Core::RakeTask.new(:spec)

desc 'Run style checker'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = true
end

# desc "Run continuous integration build"
# task ci: ['engine_cart:generate'] do
#   Rake::Task['spec'].invoke
# end

# desc 'Run continuous integration build'
# task ci: ['rubocop', 'spec']

# task default: :ci
