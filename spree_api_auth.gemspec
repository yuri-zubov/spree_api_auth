# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_api_auth'
  s.version     = '0.3.1'
  s.summary     = "Spree's Authenticattion API"
  s.description = "Spree's Authenticattion API"
  s.required_ruby_version = '>= 1.8.7'

  s.author    = 'Masahiro Saito'
  s.email     = 'camelmasa@gmail.com'
  s.homepage  = "https://github.com/camelmasa/#{s.name}"

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {spec}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 3.0'
  s.add_dependency 'spree_api', '>= 3.0'
end
