ActiveRecord::Schema.define(:version => 0) do
  create_table :social_connections, :force => true do |t|
    t.integer :source_id
    t.string :source_type
    t.integer :target_id
    t.string :target_type
  end
  create_table :social_activities, :force => true do |t|
    t.integer :owner_id
    t.string :owner_type
    t.integer :subject_id
    t.string :subject_type
    t.integer :target_id
    t.string :target_type
    t.string :verb
    t.text :options_as_json
    t.boolean :unseen, :default => true
  end

  # the 'connectables' table is for the tests
  create_table :connectables, :force => true do |t|
    t.string :name
    t.string :email
  end
end
