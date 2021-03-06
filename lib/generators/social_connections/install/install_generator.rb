require 'rails/generators/migration'

module SocialConnections

  module Generators
    puts "in 'Generators' module"
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "add the migrations"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template "create_social_connections_tables.rb", "db/migrate/create_social_connections.rb"
        migration_template "create_mute_and_curious_guests.rb", "db/migrate/create_mute_and_curious_guests.rb"
      end

    end
  end
end
