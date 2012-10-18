Gem::Specification.new do |s|
  s.name = 'Radiate360'
  s.version = '1.0.0'
  s.authors = 'Radiate Media'
  s.date = '2012-10-16'
  s.summary = 'Implements the Radiate360 api'
  s.description = 'Implements the Radiate360 api'
  s.files =  Dir["{lib}/*.rb", "{lib}/**/*.rb", "{lib}/**/**/*.rb", "*.md"]
  s.require_path = "lib"
  s.add_development_dependency 'rspec'
end
