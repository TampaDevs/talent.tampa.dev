module BusinessesHelper
  def business_attributes
    {
      user: users(:empty),
      name: "Name",
      company: "Company",
      bio: "Bio",
      phone_number: "1234567890",
      avatar: active_storage_blobs(:basecamp),
      developer_notifications: :no
    }
  end

  def create_business(options = {})
    Business.create!(business_attributes.merge(options))
  end
end
