#
# Be sure to run `pod lib lint DHAP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DHAP'
  s.version          = '0.1.0'
  s.summary          = 'Decentralised Home Automation Protocol'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An open home automation protocol that removes the need for a central controller, proprietary hardware and software.
                       DESC

  s.homepage         = 'https://github.com/aidengaripoli/DHAP'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aidengaripoli' => 'aidosgaripoli@gmail.com' }
  s.source           = { :git => 'https://github.com/aidengaripoli/DHAP.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12'

  s.source_files = 'DHAP/Classes/**/*'
  
  s.swift_versions = '5'
  
  # s.resource_bundles = {
  #   'DHAP' => ['DHAP/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
