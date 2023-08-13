#!/usr/bin/env ruby
require 'gpgme'

# Define an interface (or contract) for decryption
class Decryptor
  def decrypt(file_path)
    raise NotImplementedError
  end
end

# Provide a default implementation
class GPGDecryptor < Decryptor
  def decrypt(file_path)
    crypto = GPGME::Crypto.new
    decrypted_data = crypto.decrypt(File.open(file_path))
    #decrypted_data.to_s.strip
    decrypted_data
  end
end

class Secrit
  attr_accessor :storage

  def self.get(entry_path, storage: nil)
    new(
      storage: storage
    ).get(entry_path).to_s.strip
  end

  # Allow optional injection of custom Decryptor
  def initialize(decryptor: GPGDecryptor.new, storage: nil)
    @decryptor = decryptor
    @storage = storage || File.expand_path("~/.password-store/")
  end

  def get(entry_path)
    full_path = construct_path(entry_path)
    validate_file_existence(full_path)
    @decryptor.decrypt(full_path)
  end

  private

  def construct_path(entry_path)
    File.join(storage, "#{entry_path}.gpg")
  end

  def validate_file_existence(full_path)
    raise "File not found: #{full_path}" unless File.exist?(full_path)
  end
end
