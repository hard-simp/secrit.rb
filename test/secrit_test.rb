#!/usr/bin/env ruby
require 'minitest/autorun'
require 'mocha/minitest'
require_relative '../lib/secrit'

class SecritTest < Minitest::Test
  def with_encrypted_file(contents, key_path = 'test_entry')
    Dir.mktmpdir do |temp_dir|
      # Create a temporary GPG file with known content
      test_file_path = File.join(temp_dir, "#{key_path}.gpg")
      file = File.open(test_file_path, 'w+')

      crypto = GPGME::Crypto.new
      crypto.encrypt(contents, output: file)

      yield(temp_dir)
    end
  end

  def test_real_decryption
    # Create a temporary GPG file with known content
    key_path = 'foo_bar'

    with_encrypted_file('test content', key_path) do |storage|
      # Run the get method and check the result
      result = Secrit.get(key_path, storage: storage)
      assert_equal "test content", result
    end
  end

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

  def test_successful_decryption_object
    entry_path = "valid_entry_path"
    expected_decrypted_content = "secret content"

    # Create a mock decryptor
    mock_decryptor = Minitest::Mock.new
    mock_decryptor.expect(:decrypt, expected_decrypted_content, [String])
    File.stubs(:exist?).returns(true)

    # Create an instance of Secrit with the mock decryptor
    secrit = Secrit.new(decryptor: mock_decryptor)

    # Test the get method
    decrypted_content = secrit.get(entry_path)
    assert_equal expected_decrypted_content, decrypted_content

    # Verify that the mock expectations were met
    mock_decryptor.verify
  end

  def test_file_not_found
    # Mocking the file existence check to return false
    File.stubs(:exist?).returns(false)

    # Testing the get method to ensure it raises the correct error
    assert_raises(RuntimeError, "File not found: #{File.join(Secrit.new.storage, 'non_existent_file.gpg')}") do
      Secrit.get('non_existent_file')
    end
  end
end
