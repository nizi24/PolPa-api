common_table_name = %w(required_exp, hash_locks)
common_table_name.each do |table_name|
  path = Rails.root.join('db', 'seeds', "#{table_name}.rb")
  if File.exist?(path)
    puts "Creating #{table_name}....."
    require(path)
  end
end

sum = 0
pre = 0
300.times do |i|
  i += 1
  if i == 1
    exp = 50
  elsif i <= 15
    exp = 50 + i * 2
  elsif i <= 180
    exp = (pre * 1.1 + i * 5) / 2
  else
    exp = 1000
  end
  exp = exp.round
  sum += exp
  puts "#{i}レベル 次のレベルに必要な経験値: #{exp} 累計: #{sum}"
  pre = exp

  RequiredExp.create!(level: i, required_exp: exp, total_experience: sum)
end
