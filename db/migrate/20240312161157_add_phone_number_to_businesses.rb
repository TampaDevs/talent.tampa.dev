class AddPhoneNumberToBusinesses < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :phone_number, :string
  end
end
