# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'dudegl'
  s.version = '0.2.3'
  s.authors = ['Dmitry Khramtsov', 'Ivan Nemytchenko']
  s.email = ["dp@khramtsov.net"]
  s.summary = 'Visualization of code and OOP concepts in a form of human body'
  s.description = 'Anthropomorphic UML: visualization of code and OOP concepts in a form of human body.'
  s.homepage = 'https://github.com/dmikhr/DudeGL/wiki'
  s.license = 'MIT'
  s.files = Dir['lib/**/*'].keep_if { |file| File.file?(file) }
end
