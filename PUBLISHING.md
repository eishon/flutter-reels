# Publishing Guide

This guide explains how to create releases for Flutter Reels.

## Architecture Note

Flutter Reels uses **Option C: Hybrid Add-to-App** architecture. This means:
- **Flutter module** is integrated as source code (not published to pub.dev)
- **Native SDKs** wrap the Flutter module for easy integration
- Users integrate by including the module source in their projects

## Creating a Release

### 1. Update Version

Update version in relevant files:
- `reels_flutter/pubspec.yaml`
- `reels_android/build.gradle` (version name/code)
- `reels_ios/ReelsIOS.podspec` (version)

### 2. Update CHANGELOG

Add release notes to `CHANGELOG.md`:

```markdown
## [1.0.0] - 2025-10-22

### Added
- Initial release
- Flutter module with Pigeon API
- Android SDK wrapper
- iOS SDK wrapper
- CI/CD with GitHub Actions

### Fixed
- Bug fixes and improvements
```

### 3. Commit Changes

```bash
git add .
git commit -m "chore: Bump version to 1.0.0"
git push origin master
```

### 4. Create and Push Tag

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

### 5. Automated Release

The `release.yml` workflow will automatically:
1. Detect the new tag
2. Generate changelog
3. Create release archives (.tar.gz and .zip)
4. Create GitHub Release with assets
5. Generate integration guide

## Release Artifacts

Each release includes:
- `flutter-reels-vX.Y.Z.tar.gz` - Source code archive
- `flutter-reels-vX.Y.Z.zip` - Source code ZIP
- `INTEGRATION.md` - Integration guide
- Release notes with changelog

## Manual Release (Alternative)

If you need to create a release manually:

```bash
# 1. Create release archive
tar -czf flutter-reels-v1.0.0.tar.gz \
  reels_flutter/ \
  reels_android/ \
  reels_ios/ \
  SETUP.md \
  README.md \
  LICENSE \
  examples/

# 2. Create GitHub release
gh release create v1.0.0 \
  --title "Flutter Reels v1.0.0" \
  --notes "Release notes here" \
  flutter-reels-v1.0.0.tar.gz
```

## Version Numbering

Follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version: Breaking changes
- **MINOR** version: New features (backward compatible)
- **PATCH** version: Bug fixes (backward compatible)

Examples:
- `v1.0.0` - Initial release
- `v1.1.0` - Added new features
- `v1.1.1` - Bug fixes
- `v2.0.0` - Breaking changes

## Pre-releases

For beta/alpha releases:

```bash
git tag -a v1.0.0-beta.1 -m "Beta release"
git push origin v1.0.0-beta.1
```

Mark as pre-release in the GitHub UI or add `prerelease: true` to workflow.

## Publishing Checklist

Before creating a release:

- [ ] All tests pass locally
- [ ] CI/CD workflows pass on master
- [ ] Version numbers updated
- [ ] CHANGELOG.md updated
- [ ] Documentation up to date
- [ ] Example apps tested
- [ ] Migration guide (if breaking changes)

## Future: Package Publishing

If you want to publish to package registries later:

### Flutter (pub.dev)
- Update `pubspec.yaml` with proper metadata
- Run `flutter pub publish --dry-run`
- Run `flutter pub publish`

### Android (Maven Central)
- Configure Maven publishing in `build.gradle`
- Add signing configuration
- Publish AAR to Maven Central

### iOS (CocoaPods)
- Update `.podspec` file
- Run `pod trunk push ReelsIOS.podspec`

**Note**: For Add-to-App architecture, source integration (current approach) is often preferred over package publishing.
