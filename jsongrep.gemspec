# encoding: utf-8

Gem::Specification.new do |s|
  s.name         = 'jsongrep'
  s.version      = '0.0.3'
  s.authors      = ['Niko Dittmann']
  s.email        = 'mail@niko-dittmann.com'
  s.homepage     = 'http://github.com/niko/jsongrep'
  s.description  = 'A small gem that adds #find, #all and #destroy to a class to keep track of its instances.'
  s.summary      = s.description # for now
  
  s.files        = Dir['lib/**/*.rb']
  s.test_files   = Dir['spec/**/*_spec.rb']
  
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.executables  = ['jsongrep']
  s.bindir       = 'bin'
  
  s.add_dependency 'yajl-ruby'
  s.add_dependency 'slop'
  
  s.rubyforge_project = 'nowarning'
  s.add_development_dependency 'qed'
end
