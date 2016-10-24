namespace :gko do
  namespace :db do
    
    desc "Cleanup inquiries older than 1 month"
    task :cleanup_inquiries => :environment do
      Inquiries.where("created_at <= ?", 1.month.ago).each do |inquiry|
        inquiry.destroy
      end
    end
    
  end
end

