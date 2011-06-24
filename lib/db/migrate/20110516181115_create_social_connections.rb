class CreateSocialConnections < ActiveRecord::Migration
  def self.up
    create_table :social_connections do |t|
      t.integer :source_id
      t.string :source_type
      t.integer :target_id
      t.string :target_type
    end
  end
  def self.down
    drop_table :social_connections
  end
end
