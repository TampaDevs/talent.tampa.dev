namespace :users do
  desc "Sync registered user data to Sendgrid"
  task sync_sendgrid: :environment do
    users = User.all
    contacts = []

    users.each do |u|
      next if u.nil?

      contact = {
        first_name: u.ap_first_name,
        last_name: u.ap_last_name,
        email: u.ap_email,
        custom_fields: {
          e47_T: u.ap_types.to_s
        }
      }

      if u.developer
        contact[:custom_fields]["e16_T"] = u.developer.linkedin || ""
        contact[:custom_fields]["e18_T"] = u.developer.github || ""
        contact[:custom_fields]["e53_T"] = "1" if u.developer.codeboxx_student
        contact[:custom_fields]["e15_T"] = u.developer.website || ""
      end

      contacts << contact
    end

    sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])

    response = sg.client._("marketing/contacts").put(request_body: {contacts: contacts})

    if response.status_code != 202
      Rails.logger.error "Failed to update SendGrid contacts with error #{response.status_code} #{response.body}"
    else
      Rails.logger.info "Updated #{contacts.length} contacts(s)"
    end
  end
end
