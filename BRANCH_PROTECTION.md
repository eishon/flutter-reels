# Branch Protection & Workflow Guidelines

## 🔒 Branch Protection

The `master` and `main` branches are now protected. Direct pushes are **not allowed**.

### Branch Strategy

```
master (protected)
  └── feature/v0.0.3
      ├── feature/video-player
      ├── bugfix/some-fix
      └── ...
```

## 📋 Development Workflow

### 1. Create Feature Branch

```bash
git checkout master
git pull origin master
git checkout -b feature/your-feature-name
```

### 2. Branch Naming Convention

Follow this pattern:
- `feature/` - New features (e.g., `feature/video-player`)
- `bugfix/` - Bug fixes (e.g., `bugfix/fix-playback`)
- `hotfix/` - Urgent production fixes (e.g., `hotfix/critical-bug`)
- `release/` - Release preparation (e.g., `release/v0.0.3`)

### 3. Make Changes

```bash
# Make your changes
git add .
git commit -m "feat: add video player component"

# Push to your feature branch
git push origin feature/your-feature-name
```

### 4. Create Pull Request

1. Go to GitHub repository
2. Click "New Pull Request"
3. Select your feature branch
4. Fill in PR template with:
   - **Title**: Follow conventional commits (feat:, fix:, docs:, etc.)
   - **Description**: Explain what and why
   - **Testing**: How to test the changes
   - **Screenshots**: If UI changes

### 5. PR Review Process

✅ Automated checks must pass:
- CI tests (Flutter analyze, test, build)
- PR validation (title, description, branch name)
- Security scan (no secrets or sensitive files)
- Size check (encourage small PRs)

✅ Manual review:
- Code review by maintainer
- Approve changes
- Merge via "Squash and Merge" or "Merge Commit"

## 🚫 What's Prevented

### Direct Push to Master/Main
```bash
git push origin master  # ❌ Will fail!
```

Error message:
```
Direct pushes to master/main branch are not allowed!
Please create a pull request for your changes.
```

### Solution
Always use PRs:
```bash
git checkout -b feature/my-changes
# Make changes
git push origin feature/my-changes
# Create PR on GitHub
```

## ✅ CI Workflow Behavior

### On Feature Branches
```yaml
push to feature/* → Runs CI (analyze, test, build)
```

### On Pull Requests
```yaml
PR to master/main → Runs:
  - CI (analyze, test, build AAR)
  - PR Validation
  - Security Scan
  - Size Check
```

### On Master/Main
```yaml
push to master/main → Blocked by branch-protection.yml
merge PR to master/main → Triggers release workflows (if tagged)
```

## 📝 Conventional Commit Format

PR titles should follow:

```
<type>(<scope>): <subject>

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- style: Code style changes (formatting)
- refactor: Code refactoring
- perf: Performance improvements
- test: Adding or updating tests
- chore: Maintenance tasks
- build: Build system changes
- ci: CI/CD changes
- revert: Revert previous commit
```

Examples:
```
feat(video-player): add HLS video streaming support
fix(ui): resolve video controls flickering issue
docs(readme): update installation instructions
refactor(state): migrate to provider state management
```

## 🔄 Current Development

**Active Branch**: `feature/v0.0.3`

**Features in Development**:
- Video player with HLS support
- Reels/stories UI
- Product catalog integration
- State management with Provider

**To Contribute**:
1. Branch from `feature/v0.0.3`
2. Create sub-feature branch
3. Make changes
4. PR back to `feature/v0.0.3` first
5. When ready, PR `feature/v0.0.3` → `master`

## 📊 PR Size Guidelines

Keep PRs focused and reviewable:
- **Files changed**: < 50 files (warning at 50+)
- **Lines changed**: < 1000 lines (warning at 1000+)

**Tip**: Break large features into smaller PRs for faster review!

## 🛠️ Workflow Files

- `.github/workflows/ci.yml` - Main CI pipeline
- `.github/workflows/branch-protection.yml` - Blocks direct pushes
- `.github/workflows/pr-validation.yml` - PR quality checks
- `.github/workflows/build-android.yml` - Android builds
- `.github/workflows/build-ios.yml` - iOS builds
- `.github/workflows/release.yml` - Release automation

## 📚 Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Effective Pull Requests](https://github.blog/2015-01-21-how-to-write-the-perfect-pull-request/)

## ❓ Questions?

If you encounter issues with the workflow, please:
1. Check this guide
2. Review existing PRs
3. Ask in PR comments
4. Contact maintainers

---

**Remember**: Quality over speed. Small, focused PRs = faster reviews! 🚀
