task :seed do
    ruby "seeder.rb"
end

task :run do
    sh 'bundle exec rerun --ignore "*.{slim,js,css}" "rackup --host 0.0.0.0"'
end