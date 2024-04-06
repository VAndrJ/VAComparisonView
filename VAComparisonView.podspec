Pod::Spec.new do |s|
  s.name             = 'VAComparisonView'
  s.version          = '1.0.0'
  s.summary          = 'Slide-to-compare views.'

  s.description      = <<-DESC
  VAComparisonView library is a UIView component designed to visually compare two UIViews by sliding left or right.
                       DESC

  s.homepage         = 'https://github.com/VAndrJ/VAComparisonView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'VAndrJ' => 'vandrjios@gmail.com' }
  s.source           = { :git => 'https://github.com/VAndrJ/VAComparisonView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.linkedin.com/in/vandrj/'
  s.ios.deployment_target = '12.0'
  s.source_files = 'VAComparisonView/Classes/**/*'
  s.frameworks = 'UIKit'

  s.swift_versions = '5.7'
end
