module Developers
  module CelebrationPackageRequestsHelper
    def form_attributes
      {
        developer: developers(:one),
        address: "123 Main St\nNew York, NY 10001",
        company: "Rails for All",
        position: "Rails Developer",
        start_date: Date.today,
        employment_type: :full_time_employment,
        feedback: "Keep up the great work with Tampa Devs Talent!"
      }
    end
  end
end
