#!/usr/bin/env ruby
require 'gpgme'

# Decryptor provides an interface for decryption. Classes that extend Decryptor
# must implement the decrypt method.
class Decryptor
  # Decrypts a file at the given path.
  #
  # @param file_path [String] the path to the file to be decrypted.
  # @raise [NotImplementedError] if the method is called on the Decryptor class
  #   itself, rather than a subclass.
  def decrypt(file_path)
    raise NotImplementedError
  end
end

# GPGDecryptor is a default implementation of the Decryptor interface using GPG.
class GPGDecryptor < Decryptor
  # Decrypts a file at the given path using GPG.
  #
  # @param file_path [String] the path to the file to be decrypted.
  # @return [GPGME::Data] the decrypted data.
  def decrypt(file_path)
    crypto = GPGME::Crypto.new
    decrypted_data = crypto.decrypt(File.open(file_path))
    decrypted_data
  end
end

# Secrit provides methods to get encrypted data, allowing optional customization
# of the decryption process.
class Secrit
  attr_accessor :storage

  # Retrieves decrypted data for a given entry path.
  #
  # @param entry_path [String] the entry path to the encrypted data.
  # @param storage [String] the storage path for the encrypted files (optional).
  # @return [String] the decrypted content as a string.
  def self.get(entry_path, storage: nil)
    new(
      storage: storage
    ).get(entry_path).to_s.strip
  end

  # Initializes a new Secrit object with optional customization.
  #
  # @param decryptor [Decryptor] an object that responds to the decrypt method
  #   (optional, defaults to GPGDecryptor.new).
  # @param storage [String] the storage path for the encrypted files (optional).
  def initialize(decryptor: GPGDecryptor.new, storage: nil)
    @decryptor = decryptor
    @storage = storage || File.expand_path("~/.password-store/")
  end

  # Retrieves decrypted data for a given entry path.
  #
  # @param entry_path [String] the entry path to the encrypted data.
  # @return [GPGME::Data] the decrypted data.
  # @raise [RuntimeError] if the file does not exist at the constructed path.
  def get(entry_path)
    full_path = construct_path(entry_path)
    validate_file_existence(full_path)
    @decryptor.decrypt(full_path)
  end

  private

  # Constructs the full path to an encrypted file based on the entry path.
  #
  # @param entry_path [String] the entry path.
  # @return [String] the full path to the encrypted file.
  def construct_path(entry_path)
    File.join(storage, "#{entry_path}.gpg")
  end

  # Validates that a file exists at the given path.
  #
  # @param full_path [String] the full path to the file.
  # @raise [RuntimeError] if the file does not exist at the given path.
  def validate_file_existence(full_path)
    raise "File not found: #{full_path}" unless File.exist?(full_path)
  end
end
