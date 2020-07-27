common_table_name = %w(required_exp, hash_locks)
common_table_name.each do |table_name|
  path = Rails.root.join('db', 'seeds', "#{table_name}.rb")
  if File.exist?(path)
    puts "Creating #{table_name}....."
    require(path)
  end
end
