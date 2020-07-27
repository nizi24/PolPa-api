256.times do |i|
  HashLock.create!(table: "tags", column: "name", key: sprintf("%02x", i))
end
