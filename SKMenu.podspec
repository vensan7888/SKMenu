#
# Be sure to run `pod lib lint SS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SKMenu'
  s.version          = '0.0.1'
  s.summary          = 'SKMenu'

  s.description      = <<-DESC
Customized menu component for ios with color transforming animation, up on selection of any menu item.
                       DESC

  s.homepage         = 'https://github.com/vensan7888/SKMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sandeep Kumar M V' => 'venu.medidi@gmail.com' }
  s.source           = { :git => 'https://github.com/vensan7888/SKMenu.git', :tag => s.version.to_s }
  s.social_media_url = 'https://about.me/venu.medidi'

	s.platform         = :ios, '9.0'
	s.swift_version    = '5.0'

  s.source_files = 'Sources/**/*'

end
