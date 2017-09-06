module Hanami::Monban
  module SecurePassword
    def create_secure(user_data)
      create(changeset(NewSecureUser).data(user_data).to_h)
    end

    private

    class NewSecureUser < ROM::Changeset::Create
      map do |tuple|
        tuple.merge(
          password_hash: BCrypt::Password.create(tuple.delete(:password))
        )
      end
    end
  end
end
