# Branch Protection Configuration

This repository has branch protection rules configured to ensure code quality and prevent direct pushes to the main branch.

## Protected Branches

### Main Branch (`main`)

The `main` branch is protected with the following rules:

#### Required Rules:
1. **Pull Request Required**: All changes must be submitted through pull requests
2. **Required Approvals**: At least 1 approval required before merging
3. **Required Status Checks**: The `analyze-and-test` CI job must pass before merging

#### What This Means:
- ❌ **No direct pushes** to the `main` branch
- ✅ All changes must go through a **pull request**
- ✅ Pull requests must be **approved** by at least one reviewer
- ✅ CI checks must **pass** before merging

## Workflow for Contributing

1. **Create a feature branch** from `main`:
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** and commit:
   ```bash
   git add .
   git commit -m "Your descriptive commit message"
   ```

3. **Push your branch** to the remote:
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create a pull request** on GitHub:
   - Go to the repository on GitHub
   - Click "Pull requests" → "New pull request"
   - Select your feature branch
   - Fill in the PR description
   - Submit the pull request

5. **Wait for approval and CI checks**:
   - CI will automatically run tests and checks
   - At least one reviewer must approve your PR
   - All status checks must pass

6. **Merge the pull request**:
   - Once approved and checks pass, you can merge
   - Choose your preferred merge strategy (merge commit, squash, or rebase)

## Setting Up Branch Protection (For Repository Administrators)

The ruleset configuration is stored in `.github/rulesets/main-branch-protection.json`. 

To apply this ruleset:

### Option 1: Via GitHub Web Interface

1. Go to repository **Settings** → **Rules** → **Rulesets**
2. Click **New ruleset** → **New branch ruleset**
3. Configure the ruleset with the following settings:
   - **Name**: Protect Main Branch
   - **Enforcement status**: Active
   - **Target branches**: `main`
   - **Branch protection rules**:
     - ✅ Require a pull request before merging
       - Required approvals: 1
     - ✅ Require status checks to pass
       - Required checks: `analyze-and-test`
4. Save the ruleset

### Option 2: Via GitHub API

You can use the GitHub API to create the ruleset programmatically. See the [GitHub Rulesets API documentation](https://docs.github.com/en/rest/repos/rules).

### Option 3: Import from Configuration File

The `.github/rulesets/main-branch-protection.json` file contains the ruleset configuration that can be imported or used as a reference.

## CI/CD Integration

The branch protection is integrated with the CI workflow:

- **Workflow**: `.github/workflows/ci.yml`
- **Job Name**: `analyze-and-test`
- **Checks Performed**:
  - Code formatting verification
  - Static code analysis
  - Unit tests with coverage
  - AAR build check

### Automated Workflows

In addition to the required CI checks, the following workflows run automatically:

- **Auto-Format Pigeon** (`.github/workflows/auto-format-pigeon.yml`)
  - Automatically regenerates Pigeon code when `pigeons/messages.dart` is modified
  - Formats generated files with `dart format`
  - Commits changes back to the branch with `[skip ci]` to prevent loops
  - Ensures type-safe platform communication code is always up-to-date

## Troubleshooting

### "Protected branch update failed"

If you see this error, it means you tried to push directly to `main`. Follow the workflow above to create a pull request instead.

### "Required status check is missing"

Make sure the CI workflow completes successfully. Check the "Actions" tab for any failures.

### "Review required"

Your pull request needs approval from at least one reviewer before it can be merged.

## Additional Resources

- [GitHub Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
- [Pull Request Best Practices](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests)
