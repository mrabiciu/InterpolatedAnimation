Pod::Spec.new do |s|
  s.name         = "InterpolatedAnimation"
  s.version      = "0.0.1"
  s.summary      = "A short description of InterpolatedAnimation."
  s.description  = "I have the best descriptions, nobody is better at descriptions than me"
  s.homepage     = "http://EXAMPLE/InterpolatedAnimation"
  s.license      = "MIT"
  s.author       = { "Maxim Rabiciuc" => "mrabiciu@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source = { :git => 'https://github.com/mrabiciu/InterpolatedAnimation.git' }
  s.source_files  = 'InterpolatedAnimation/*.swift', 'InterpolatedAnimation/*.h'
  s.public_header_files = 'InterpolatedAnimation/*.h'
  s.requires_arc = true
end
