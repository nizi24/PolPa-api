common_table_name = %w(required_exp)
common_table_name.each do |table_name|
  path = Rails.root.join('db', 'seeds', "#{tabel_name}.rb")
  if File.exist?(path)
    puts "Creating #{tabel_name}....."
    require(path)
  end
end
