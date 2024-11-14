class CreateLinkedinProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :linkedin_profiles do |t|
      t.string :username
      t.json :raw_data
      t.string :status

      t.timestamps
    end
  end
end
