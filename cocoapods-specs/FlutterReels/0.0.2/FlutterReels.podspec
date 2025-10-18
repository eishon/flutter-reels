Pod::Spec.new do |s|
  s.name             = 'FlutterReels'
  s.version = '0.0.2'
  s.summary          = 'A Flutter module for displaying reels/stories that can be integrated into native iOS apps'
  s.description      = <<-DESC
Flutter Reels is a Flutter module that provides reels/stories functionality 
that can be seamlessly integrated into native iOS applications using CocoaPods.
                       DESC

  s.homepage         = 'https://github.com/eishon/flutter-reels'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'eishon' => 'eishon.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/eishon/flutter-reels.git', :tag => "v#{s.version}" }

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  # Framework files will be downloaded from releases
  s.source_files = 'FlutterReels/Classes/**/*'
  s.vendored_frameworks = 'Frameworks/*.xcframework'
  
  # Dependencies
  s.dependency 'Flutter'
  
  # Prepare command to download frameworks
  s.prepare_command = <<-CMD
    mkdir -p Frameworks
    
    # Download the frameworks from GitHub releases
    VERSION=#{s.version}
    REPO_URL="https://github.com/eishon/flutter-reels"
    
    # Download and extract Flutter frameworks
    curl -L "${REPO_URL}/releases/download/v${VERSION}/flutter_reels-ios.zip" -o frameworks.zip
    unzip -o frameworks.zip -d Frameworks
    rm frameworks.zip
    
    # Create a dummy Classes directory if it doesn't exist
    mkdir -p FlutterReels/Classes
    touch FlutterReels/Classes/.gitkeep
  CMD
end
