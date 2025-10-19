# Contributing to Flutter Reels

First off, thank you for considering contributing to Flutter Reels! It's people like you that make Flutter Reels such a great tool.

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct:
- Be respectful and inclusive
- Be collaborative
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps which reproduce the problem**
- **Provide specific examples to demonstrate the steps**
- **Describe the behavior you observed after following the steps**
- **Explain which behavior you expected to see instead and why**
- **Include screenshots and animated GIFs** if possible
- **Include your environment details**: Flutter version, OS, etc.

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- **Use a clear and descriptive title**
- **Provide a step-by-step description of the suggested enhancement**
- **Provide specific examples to demonstrate the steps**
- **Describe the current behavior** and **explain which behavior you expected to see instead**
- **Explain why this enhancement would be useful**

### Pull Requests

- Fill in the required template
- Do not include issue numbers in the PR title
- Follow the Dart/Flutter style guide
- Include screenshots and animated GIFs in your pull request whenever possible
- Document new code
- End all files with a newline

## Development Process

### Branch Protection

The `main` branch is protected and **does not allow direct pushes**. All changes must be made through pull requests. See [Branch Protection Documentation](.github/BRANCH_PROTECTION.md) for details.

1. **Fork the repository** and create your branch from `main`

   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/my-new-feature
   ```

2. **Install dependencies**

   ```bash
   cd flutter_reels
   flutter pub get
   ```

3. **Make your changes**
   - Write clean, readable code
   - Follow Dart/Flutter conventions
   - Add tests for new features

4. **Run tests and checks**

   ```bash
   # Format code
   dart format lib test
   
   # Analyze code
   flutter analyze
   
   # Run tests
   flutter test
   ```

5. **Commit your changes**

   ```bash
   git commit -m "Add some feature"
   ```

   **Commit Message Guidelines:**
   - Use the present tense ("Add feature" not "Added feature")
   - Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
   - Limit the first line to 72 characters or less
   - Reference issues and pull requests liberally after the first line

6. **Push to your fork**

   ```bash
   git push origin feature/my-new-feature
   ```

7. **Open a Pull Request**
   - Provide a clear description of the problem and solution
   - Include the relevant issue number if applicable
   - Include screenshots if your changes affect the UI
   - Wait for at least one approval from a reviewer
   - Ensure all CI checks pass (the `analyze-and-test` job must succeed)

## Style Guidelines

### Dart Style Guide

- Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format your code
- Maximum line length: 80 characters

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line
- Consider starting the commit message with an applicable emoji:
  - 🎨 `:art:` when improving the format/structure of the code
  - 🐛 `:bug:` when fixing a bug
  - ✨ `:sparkles:` when introducing new features
  - 📝 `:memo:` when writing docs
  - 🚀 `:rocket:` when improving performance
  - ✅ `:white_check_mark:` when adding tests
  - 🔒 `:lock:` when dealing with security

## Testing

- Write tests for all new features
- Ensure all tests pass before submitting a PR
- Aim for high test coverage

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Documentation

- Update the README.md with details of changes to the interface
- Update the documentation in the `docs/` folder if applicable
- Comment your code where necessary
- Update the CHANGELOG.md for significant changes

## Release Process

Releases are handled by the maintainers:

1. Update version in `pubspec.yaml`
2. Update CHANGELOG.md
3. Create a git tag: `git tag v1.0.0`
4. Push the tag: `git push origin v1.0.0`
5. GitHub Actions will automatically build and create a release

## Questions?

Feel free to open an issue with your question or reach out to the maintainers.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing! 🎉
