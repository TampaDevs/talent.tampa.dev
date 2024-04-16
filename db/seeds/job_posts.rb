Business.all.each do |business|
  SeedsHelper.create_job_posts!(business)
end