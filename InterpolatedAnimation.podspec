Pod::Spec.new do |s|
  s.name         = "InterpolatedAnimation"
  s.version      = "0.1.0"
  s.summary      = "Library for building complex gesture driven animations"
  s.homepage     = "https://github.com/mrabiciu/InterpolatedAnimation"
  s.license      = { :type => 'MIT', :file => 'License.txt' }
  s.author       = { "Max Rabiciuc" => "mrabiciu@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source = { :git => 'https://github.com/mrabiciu/InterpolatedAnimation.git', :tag => 'v' + s.version.to_s }
  s.source_files  = 'InterpolatedAnimation/*.swift', 'InterpolatedAnimation/*.h'
  s.public_header_files = 'InterpolatedAnimation/*.h'
  s.requires_arc = true
end
