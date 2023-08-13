#!/usr/bin/env ruby
require 'minitest/autorun'
require 'mocha/minitest'
require_relative '../lib/secrit'

class SecritTest < Minitest::Test
  def test_successful_decryption
    # Mocking the file existence check
    File.stubs(:exist?).returns(true)

    # Mocking the file reading
    encrypted_file = StringIO.new("encrypted content")
    File.stubs(:open).returns(encrypted_file)

    # Mocking the decryption
    decrypted_data = GPGME::Data.new("decrypted content")
    GPGME::Crypto.any_instance.stubs(:decrypt).returns(decrypted_data)

    # Testing the get method
    result = Secrit.get('valid_entry_path')
    assert_equal 'decrypted content', result
  end

  def test_file_not_found
    # Mocking the file existence check to return false
    File.stubs(:exist?).returns(false)

    # Testing the get method to ensure it raises the correct error
    assert_raises(RuntimeError, "File not found: #{File.join(PASSWORD_STORE_PATH, 'non_existent_file.gpg')}") do
      Secrit.get('non_existent_file')
    end
  end
end
