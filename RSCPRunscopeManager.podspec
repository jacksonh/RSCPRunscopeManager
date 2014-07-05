#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RSCPRunscopeManager"
  s.version          = "0.1.0"
  s.summary          = "Proxy all your HTTP requests through Runscope"
  s.homepage         = "https://github.com/jacksonh/RSCPRunscopeManager"
  s.license          = 'MIT'
  s.author           = { "Jackson Harper" => "jacksonh@gmail.com" }
  s.source           = { :git => "https://github.com/jacksonh/RSCPRunscopeManager.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/jacksonh'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'RSCPRunscopeManager.m'
  s.public_header_files = 'RSCPRunscopeManager.h'

end
