Gem::Specification.new do |s|
  s.name        = 'recurse-delete'
  s.version     = '0.0.8'
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = "Delete records efficiently"
  s.description = "Recursively delete all dependent model associations without an N + 1"
  s.authors     = ["JD Isaacks"]
  s.email       = 'john.isaacks@programming-perils.com'
  s.files       = ["lib/recurse-delete.rb"]
  s.homepage    = 'https://github.com/jisaacks/recurse-delete'

  s.add_dependency('activerecord', '>= 3.2.3')
  s.add_dependency('activesupport', '>= 3.2.3')
end