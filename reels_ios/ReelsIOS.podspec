Pod::Spec.new do |s|
  s.name             = 'ReelsIOS'
  s.version          = '0.1.0-beta.1'
  s.summary          = 'Flutter Reels iOS SDK'
  s.description      = <<-DESC
  Native iOS wrapper for Flutter Reels module - Hybrid Add-to-App architecture
                       DESC

  s.homepage         = 'https://github.com/eishon/flutter-reels'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Eishon' => 'eishon@example.com' }
  s.source           = { :git => 'https://github.com/eishon/flutter-reels.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/ReelsIOS/**/*.{swift,h,m}'
  
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'VALID_ARCHS' => 'arm64 x86_64'
  }
end
