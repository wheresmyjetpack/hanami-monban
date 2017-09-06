require 'bcrypt'

module Hanami::Monban
  class HashedPassword
    def self.hashed(plain_text)
      PASSWORD_HASHER.create(plain_text) 
    end

    def self.from(password_hash)
      PASSWORD_HASHER.new(password_hash)
    end

    private

    PASSWORD_HASHER = BCrypt::Password
  end
end
