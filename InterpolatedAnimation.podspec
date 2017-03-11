Pod::Spec.new do |s|
  s.name         = "InterpolatedAnimation"
  s.version      = "0.1.0"
  s.summary      = "A library for building complex gesture driven animations"
  s.description  = "Build complex gesture drive animations with very little overhead. Use whatever layout system you prefer and APIs that you're already familiar with"
  s.homepage     = "https://github.com/mrabiciu/InterpolatedAnimation"
  s.license      = { :type => 'MIT' }
  s.author       = { "Max Rabiciuc" => "mrabiciu@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source = { :git => 'https://github.com/mrabiciu/InterpolatedAnimation.git', :tag => 'v0.1.0' }
  s.source_files  = 'InterpolatedAnimation/*.swift', 'InterpolatedAnimation/*.h'
  s.public_header_files = 'InterpolatedAnimation/*.h'
  s.requires_arc = true
end
