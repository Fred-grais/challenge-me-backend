class CreateConversations < ActiveRecord::Migration[5.2]
  def up
    create_table :conversations do |t|
      t.string :recipients, array: true, null: false

      t.timestamps
    end

    execute <<-SQL
      CREATE FUNCTION sort_array(unsorted_array anyarray) RETURNS anyarray AS $$
        BEGIN
          RETURN (SELECT ARRAY_AGG(val) AS sorted_array
          FROM (SELECT UNNEST(unsorted_array) AS val ORDER BY val) AS sorted_vals);
        END;
      $$ LANGUAGE plpgsql IMMUTABLE STRICT;

      CREATE UNIQUE INDEX index_conversations_on_unique_recipients ON conversations (sort_array(recipients));
      CREATE INDEX index_conversations_on_recipients ON conversations USING GIN (recipients);
    SQL
  end

  def down
    drop_table :conversations
    execute <<-SQL
      DROP INDEX IF EXISTS index_conversations_on_unique_recipients;
      DROP INDEX IF EXISTS index_conversations_on_recipients;
      DROP FUNCTION IF EXISTS sort_array(unsorted_array anyarray);
    SQL
  end
end
