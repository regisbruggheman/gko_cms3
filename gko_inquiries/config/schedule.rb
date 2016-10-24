set :environment, "production"
case @environment
when 'production'
  every day, :roles => [:db] do
    rake "gko:db:dump" # Dump db onserver before all
    rake "gko:db:cleanup_inquiries"
  end
end