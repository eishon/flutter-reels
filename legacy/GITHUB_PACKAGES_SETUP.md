# GitHub Packages Setup Guide

This guide explains how to use Flutter Reels module from GitHub Packages for private repository distribution.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setting Up Authentication](#setting-up-authentication)
- [Android Integration](#android-integration)
- [iOS Integration](#ios-integration)
- [Troubleshooting](#troubleshooting)

## Overview

Flutter Reels is distributed via **GitHub Packages**, which allows secure, authenticated access to the module while keeping the repository private.

### Why GitHub Packages?

- ✅ Keep repository private
- ✅ Secure, token-based authentication
- ✅ Built-in version management
- ✅ Free for private repositories (with usage limits)
- ✅ Integrated with GitHub

## Prerequisites

Before you begin, you need:

1. **GitHub Account** - Must have access to the flutter-reels repository
2. **Personal Access Token (PAT)** - For authentication
3. **Repository Access** - Owner must grant you read access to the repo

## Setting Up Authentication

### Step 1: Create Personal Access Token (PAT)

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Give it a descriptive name: `Flutter Reels Access`
4. Select scopes:
   - ✅ `read:packages` - Download packages from GitHub Packages
   - ✅ `repo` (if accessing private repository)
5. Click "Generate token"
6. **Copy the token immediately** - you won't see it again!

### Step 2: Store Token Securely

#### For Android Development

Create or edit `~/.gradle/gradle.properties`:

**On Windows:**
```
C:\Users\YourUsername\.gradle\gradle.properties
```

**On macOS/Linux:**
```
~/.gradle/gradle.properties
```

Add these lines:
```properties
githubUsername=your-github-username
githubToken=ghp_your_personal_access_token_here
```

**Security Note:** Never commit this file to version control!

#### For iOS Development

Configure git credentials helper:

```bash
# Use credential helper
git config --global credential.helper store

# Add credentials (will be stored in ~/.git-credentials)
echo "https://your-github-username:ghp_your_token@github.com" >> ~/.git-credentials
```

**Alternative (more secure):** Use macOS Keychain or Windows Credential Manager

## Android Integration

### Step 1: Add GitHub Packages Repository

Edit your project's `settings.gradle` (or `settings.gradle.kts`):

**Groovy (settings.gradle):**
```groovy
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        
        // GitHub Packages for Flutter Reels
        maven {
            url = uri("https://maven.pkg.github.com/eishon/flutter-reels")
            credentials {
                username = project.findProperty("githubUsername") ?: System.getenv("GITHUB_USERNAME")
                password = project.findProperty("githubToken") ?: System.getenv("GITHUB_TOKEN")
            }
        }
    }
}
```

**Kotlin (settings.gradle.kts):**
```kotlin
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        
        // GitHub Packages for Flutter Reels
        maven {
            url = uri("https://maven.pkg.github.com/eishon/flutter-reels")
            credentials {
                username = project.findProperty("githubUsername") as String? 
                    ?: System.getenv("GITHUB_USERNAME")
                password = project.findProperty("githubToken") as String? 
                    ?: System.getenv("GITHUB_TOKEN")
            }
        }
    }
}
```

### Step 2: Add Dependency

In your app's `build.gradle`:

```groovy
dependencies {
    implementation 'com.github.eishon:flutter-reels:0.0.1'
    
    // Or use dynamic versioning
    implementation 'com.github.eishon:flutter-reels:+'  // Latest version
    implementation 'com.github.eishon:flutter-reels:0.0.+'  // Latest patch
}
```

### Step 3: Configure Android Project

Add to your `app/build.gradle`:

```groovy
android {
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

### Step 4: Sync and Use

```bash
./gradlew clean build
```

Then use in your code:

```java
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Launch Flutter module
        startActivity(
            FlutterActivity.createDefaultIntent(this)
        );
    }
}
```

## iOS Integration

### Step 1: Add GitHub Source to Podfile

Edit your `Podfile`:

```ruby
source 'https://github.com/eishon/flutter-reels.git'
source 'https://cdn.cocoapods.org/'

platform :ios, '12.0'

target 'YourApp' do
  use_frameworks!
  
  # Flutter Reels from GitHub Packages
  pod 'FlutterReels', '~> 0.0.1'
end
```

### Step 2: Authenticate Git

Before running `pod install`, ensure git is authenticated:

```bash
# Test authentication
git ls-remote https://github.com/eishon/flutter-reels.git

# If prompted, enter:
# Username: your-github-username
# Password: your-personal-access-token (not your GitHub password!)
```

### Step 3: Install Pods

```bash
pod install
```

### Step 4: Open Workspace

**Important:** Always use the `.xcworkspace` file:

```bash
open YourApp.xcworkspace
```

### Step 5: Use in Your Code

```swift
import UIKit
import Flutter

class ViewController: UIViewController {
    
    lazy var flutterEngine = FlutterEngine(name: "flutter_reels_engine")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flutterEngine.run()
    }
    
    @objc func openFlutterReels() {
        let flutterViewController = FlutterViewController(
            engine: flutterEngine,
            nibName: nil,
            bundle: nil
        )
        flutterViewController.modalPresentationStyle = .fullScreen
        present(flutterViewController, animated: true)
    }
}
```

## CI/CD Setup

### For GitHub Actions

If your project uses GitHub Actions, add secrets:

1. Go to your repository → Settings → Secrets and variables → Actions
2. Add repository secrets:
   - `GITHUB_USERNAME`: Your GitHub username
   - `GITHUB_TOKEN`: Your personal access token

Use in workflow:

```yaml
- name: Configure Gradle
  run: |
    mkdir -p ~/.gradle
    echo "githubUsername=${{ secrets.GITHUB_USERNAME }}" >> ~/.gradle/gradle.properties
    echo "githubToken=${{ secrets.GITHUB_TOKEN }}" >> ~/.gradle/gradle.properties

- name: Build Android
  run: ./gradlew assembleRelease
```

### For Other CI Systems

Set environment variables:

```bash
export GITHUB_USERNAME=your-username
export GITHUB_TOKEN=your-token
```

## Troubleshooting

### Android Issues

#### Error: "Could not resolve com.github.eishon:flutter-reels"

**Solution 1:** Check credentials in `~/.gradle/gradle.properties`
```bash
# Verify file exists and has correct content
cat ~/.gradle/gradle.properties
```

**Solution 2:** Try environment variables instead
```bash
export GITHUB_USERNAME=your-username
export GITHUB_TOKEN=your-token
./gradlew clean build --refresh-dependencies
```

**Solution 3:** Clear Gradle cache
```bash
./gradlew clean
rm -rf ~/.gradle/caches
./gradlew build --refresh-dependencies
```

#### Error: "HTTP 401 Unauthorized"

Your token doesn't have the right permissions. Create a new token with:
- ✅ `read:packages`
- ✅ `repo` (for private repositories)

#### Error: "HTTP 403 Forbidden"

You don't have access to the repository. Contact the repository owner to grant you access.

### iOS Issues

#### Error: "Unable to find a specification for FlutterReels"

**Solution 1:** Verify git authentication
```bash
git ls-remote https://github.com/eishon/flutter-reels.git
```

**Solution 2:** Update CocoaPods and clear cache
```bash
pod repo update
pod cache clean --all
pod deintegrate
pod install
```

#### Error: "Authentication failed"

Configure git credential helper:
```bash
git config --global credential.helper store
```

Then authenticate once:
```bash
git clone https://github.com/eishon/flutter-reels.git test-auth
# Enter username and token when prompted
rm -rf test-auth
```

#### Error: "The platform of the target is not compatible"

Update your Podfile:
```ruby
platform :ios, '12.0'  # Minimum required version
```

### General Issues

#### Stale Dependencies

Force refresh:

**Android:**
```bash
./gradlew clean build --refresh-dependencies
```

**iOS:**
```bash
pod deintegrate
pod install
```

#### Version Not Found

Check available versions:
```bash
# View releases
curl -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/repos/eishon/flutter-reels/releases
```

#### Token Expiration

Personal Access Tokens can expire. If you get authentication errors:
1. Check token expiration in GitHub Settings
2. Generate a new token if expired
3. Update stored credentials

## Security Best Practices

### 1. Token Security

- ❌ Never commit tokens to version control
- ❌ Never share tokens publicly
- ✅ Use environment variables or secure credential storage
- ✅ Set token expiration dates
- ✅ Use minimum required permissions

### 2. Add to .gitignore

```gitignore
# Gradle credentials
gradle.properties
local.properties

# Git credentials
.git-credentials

# Environment files
.env
.env.local
```

### 3. Team Access

For teams:
1. Create a **machine user** account on GitHub
2. Grant repository access to machine user
3. Generate token for machine user
4. Share machine user credentials securely (e.g., via password manager)

### 4. Revoke Unused Tokens

Regularly audit and revoke unused tokens:
- GitHub Settings → Developer settings → Personal access tokens
- Review and delete unused tokens

## Usage Limits

GitHub Packages has the following limits:

| Plan | Storage | Data Transfer |
|------|---------|---------------|
| Free | 500 MB | 1 GB/month |
| Pro | 2 GB | 10 GB/month |
| Team | 2 GB | 10 GB/month |
| Enterprise | 50 GB | 100 GB/month |

**Note:** Public packages don't count against limits.

## Support

For issues:
1. Check [Troubleshooting](#troubleshooting) section
2. Review [GitHub Packages documentation](https://docs.github.com/en/packages)
3. Open an issue on the repository
4. Contact repository maintainers

## Additional Resources

- [GitHub Packages Documentation](https://docs.github.com/en/packages)
- [Creating Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [Gradle Integration Guide](./GRADLE_INTEGRATION.md)
- [CocoaPods Integration Guide](./COCOAPODS_INTEGRATION.md)

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
