Gem::Specification.new do |spec|
  spec.name          = "secrit"
  spec.version       = "0.0.1"
  spec.summary       = "Decrypt passwords in Password-Store ('pass')"
  spec.description   = "This gem provides a method to decrypt and retrieve secrets from Password-Store ('pass' cli tool; see: https://www.passwordstore.org/)."
  spec.authors       = ["Simpthy"]

  spec.files         = ["lib/secrit.rb"]
  spec.require_paths = ["lib"]
  spec.add_dependency "gpgme", "~> 2.0.22"

  spec.homepage      = "https://github.com/hard-simp/secrit.rb"
  spec.license       = "MIT"
end
