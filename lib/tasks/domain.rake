namespace :domain do
  task :update_all => :environment do
      domains = Domain.all
      count = 0
      for domain in domains
        domain.fetch_and_save
        count += 1
      end
      puts "Total number of domains looped threw: " + count.to_s
    end
end