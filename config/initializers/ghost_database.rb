GHOST_DATABASE = YAML.load_file(File.join(Rails.root, 'config', 'ghost_database.yml'))[Rails.env.to_s]