#
# Be sure to run `pod lib lint ViewStates.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ViewStates'
  s.version          = '1.0.0'
  s.summary          = 'ViewStates makes it easier to create a view with loading, success, no data and error states'
  s.swift_version = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ViewStates makes it easier to create a view with loading, success, no data and error states. It also has an action button, so that we can do some action such as navigate to other view, or retry an async task. The UI can be customized easily.
                       DESC

  s.homepage         = 'https://github.com/thanhtanh/ViewStates'
  s.screenshots     = 'https://github.com/thanhtanh/ViewStates/raw/master/images/custom_theme.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'thanhtanh72@gmail.com' => 'thanhtanh72@gmail.com' }
  s.source           = { :git => 'https://github.com/thanhtanh/ViewStates.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ViewStates/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ViewStates' => ['ViewStates/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
