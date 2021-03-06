#
# Be sure to run `pod lib lint SimpleNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SimpleNetworking'
  s.version          = '0.1.1'
  s.summary          = 'URLSession based small library for networking'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
URLSession based small library for networking. No extra library is used.
                       DESC

  s.homepage         = 'https://github.com/david-grigoryan-dev/SimpleNetworking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Davit Grigoryan' => 'davit.grigoryan.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/david-grigoryan-dev/SimpleNetworking.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_versions = '5.4'

  s.source_files = 'SimpleNetworking/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SimpleNetworking' => ['SimpleNetworking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
