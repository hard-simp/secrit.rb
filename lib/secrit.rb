#!/usr/bin/env ruby
require 'gpgme'

PASSWORD_STORE_PATH = File.expand_path("~/.password-store/")

class Secrit
  def self.get(entry_path)
    full_path = File.join(PASSWORD_STORE_PATH, "#{entry_path}.gpg")

    # Ensure the file exists
    raise "File not found: #{full_path}" unless File.exist?(full_path)

    # Decrypt the file
    crypto = GPGME::Crypto.new
    decrypted_data = crypto.decrypt(File.open(full_path))

    # Return the decrypted content
    decrypted_data.to_s.strip
  end
end
