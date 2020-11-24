#
# Be sure to run `pod lib lint SYCustomCamera.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SYCustomCamera'
  s.version          = '0.1.6'
  s.summary          = 'SYCustomCamera is CustomCamera'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/bsytt/SYCustomCamera'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bsytt' => '15893398117@163.com' }
  s.source           = { :git => 'https://github.com/bsytt/SYCustomCamera.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SYCustomCamera/Classes/**/*'
  s.subspec 'View' do |ss|
        ss.source_files = 'SYCustomCamera/Classes/View/*.{h,m,swift}'
  end
#
#    s.subspec 'ZXUIView' do |ss|
#        ss.source_files = 'ZXTestOCUIKit/Classes/ZXUIView/*.{h,m}'
#    end
  s.resource = "SYCustomCamera/Classes/**/**/*.{xib}"
   s.resource_bundles = {
     'SYCustomCamera' => ['SYCustomCamera/Assets/*.png']
   }
#  s. = true
  #s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.dependency 'SnapKit'
  s.dependency 'TOCropViewController'
end
