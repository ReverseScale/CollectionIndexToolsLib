#
# Be sure to run `pod lib lint CollectionIndexToolsLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CollectionIndexToolsLib'
  s.version          = '0.3.0'
  s.summary          = 'Custom IndexTools similar to TableViews index bar'

  s.description      = <<-DESC
  I believe you must have thought about adding an index like Table View to Collection View. I will give you one today.
                       DESC

  s.homepage         = 'https://github.com/ReverseScale/CollectionIndexToolsLib'
  s.license          = 'MIT'
  s.author           = { 'ReverseScale' => 'reversescale@icloud.com' }
  s.source           = { :git => 'https://github.com/ReverseScale/CollectionIndexToolsLib.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CollectionIndexToolsLib/Classes/**/*'
  
  s.requires_arc = true

end
