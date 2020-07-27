class HashLock < ApplicationRecord

  def self.acquire(table, column, value)
    HashLock.where(table: table, column: column,
      key: Digest::MD5.hexdigest(value)[0,2]).lock(true).first!
  end
end
