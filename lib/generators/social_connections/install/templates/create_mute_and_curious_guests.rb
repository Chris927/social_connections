class CreateMuteAndCuriousGuests < ActiveRecord::Migration
  def self.up
    create_table :mute_and_curious_guests do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :mute_and_curious_guests
  end
end
