class AddPhoneNumberToSchoolAddresses < ActiveRecord::Migration
  def change
    add_column :school_addresses, :phone_number, :string
  end
end
