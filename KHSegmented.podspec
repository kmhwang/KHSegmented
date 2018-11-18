#
# Be sure to run `pod lib lint KHSegmented.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KHSegmented'
  s.version          = '0.1.2'
  s.summary          = 'KHSegmented is a tool set for creating segmented view controller.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
KHSegmented is a light wight tool set for creating segmented view controller written in Swift.
                       DESC

  s.homepage         = 'https://github.com/kmhwang/KHSegmented'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ken M. Hwang' => '781768+kmhwang@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/kmhwang/KHSegmented.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.2'

  s.source_files = 'KHSegmented/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KHSegmented' => ['KHSegmented/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
