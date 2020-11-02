#
# Be sure to run `pod lib lint UMKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UMKit'
  s.version          = '2.0.0'
  s.summary          = 'A short description of UMKit.'
  s.homepage         = 'https://github.com/umobi/UMKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/UMKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'
  s.macos.deployment_target = '10.15'

  s.swift_version = '5.3'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.source_files = 'Sources/UMKit/**/*'
end
