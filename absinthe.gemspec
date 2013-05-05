Gem::Specification.new do |s|
  gem_files = [ 'README.md', 'CHANGELOG.md', 'LICENCE' ]
  gem_files += Dir.glob("lib/**/*.rb")
  gem_files += Dir.glob("test/**/*.rb")

  s.name         = 'absinthe'
  s.version      = '0.0.2'
  s.platform     = Gem::Platform::RUBY
  s.license      = 'bsd'
  s.summary      = "Absinthe is an opinioned IoC container for Ruby."
  s.description  = "Not yet suitable for production use!"
  s.authors      = ["Lance Cooper"]
  s.email        = 'lance.m.cooper@gmail.com'
  s.files        = gem_files
  s.require_path = 'lib'
  s.homepage     = 'https://github.com/deathwish/absinthe'
end
