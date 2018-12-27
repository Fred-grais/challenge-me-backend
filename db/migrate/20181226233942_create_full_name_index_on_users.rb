class CreateFullNameIndexOnUsers < ActiveRecord::Migration[5.2]
  def up
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')
    execute <<-SQL
      CREATE INDEX index_users_on_fullname ON users USING gin (lower(first_name || ' ' || last_name) gin_trgm_ops);
    SQL
  end

  def down
    disable_extension 'pg_trgm' if extension_enabled?('pg_trgm')
    execute <<-SQL
      DROP INDEX IF EXISTS index_users_on_fullname;
    SQL
  end
end
