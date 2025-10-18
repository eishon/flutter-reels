# Flutter Reels CocoaPods Specs Repository

This branch contains the CocoaPods podspecs for Flutter Reels.

## Usage

Add this to your `Podfile`:

```ruby
source 'https://github.com/eishon/flutter-reels.git'
source 'https://cdn.cocoapods.org/'

target 'YourApp' do
  use_frameworks!
  
  # Flutter Reels module
  pod 'FlutterReels', '~> 0.0.2'
end
```

Then run:

```bash
pod install
```

For more information, visit: https://github.com/eishon/flutter-reels
