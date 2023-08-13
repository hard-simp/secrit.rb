Gem::Specification.new do |spec|
  spec.name          = "secrit"
  spec.version       = "0.0.6"
  spec.summary       = "Password-Store (or 'pass') managed secrets in your Ruby"
  spec.description   = "This gem provides a method to decrypt and retrieve secrets from Password-Store ('pass' cli tool; see: https://www.passwordstore.org/)."
  spec.authors       = ["Simpthy"]

  spec.files         = ["lib/secrit.rb"]
  spec.files        += Dir["test/**/*"]

  spec.require_paths = ["lib"]
  spec.add_dependency "gpgme", "~> 2.0.22"
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'mocha', '~> 1.11'

  spec.homepage      = "https://github.com/hard-simp/secrit.rb"
  spec.license       = "MIT"
end
