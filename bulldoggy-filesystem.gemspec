# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require './lib/version'

Gem::Specification.new do |s|
  s.name = "bulldoggy-filesystem"
  s.summary = 'A filesystem repository strategy for bulldoggy apps'

  s.files =  `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec}/*`.split("\n")
  s.require_path = ['lib']
  s.version = BulldoggyFilesystem::VERSION
  s.license = 'MIT'

  s.add_dependency 'bulldoggy', '~> 0.0.7.alpha'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'rspec-its', '~> 1.0.0.pre'
  s.add_development_dependency 'rake'

  s.homepage = 'https://github.com/philss/bulldoggy-filesystem'

  s.author = 'Philip Sampaio Silva'
  s.email  = 'philip.sampaio@gmail.com'
end
