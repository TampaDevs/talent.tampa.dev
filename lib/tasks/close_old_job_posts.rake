namespace :job_posts do
  desc "Close job posts older than 90 days"
    task close_old: :environment do
      Businesses::JobPost.where('created_at < ?', 90.days.ago).where(status: :open).update_all(status: :closed)
      puts "Closed job posts older than 90 days"
  end
end