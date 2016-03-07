namespace :call do
  task :send => :environment do
    puts "Hello from #{Time.current}"
  end
end