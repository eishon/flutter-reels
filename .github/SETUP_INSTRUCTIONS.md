# Branch Protection Setup Instructions

## Overview

This pull request adds branch protection configuration to prevent direct pushes to the `main` branch. All changes must now go through pull requests.

## What Was Added

1. **Ruleset Configuration** (`.github/rulesets/main-branch-protection.json`)
   - Contains the JSON configuration for branch protection
   - Requires pull requests with at least 1 approval
   - Requires the `analyze-and-test` CI check to pass

2. **Documentation** (`.github/BRANCH_PROTECTION.md`)
   - Comprehensive guide for developers on the branch protection rules
   - Step-by-step workflow for contributing
   - Troubleshooting section
   - Administrator instructions

3. **Updated Contributing Guidelines** (`CONTRIBUTING.md`)
   - Added branch protection notice
   - Updated workflow to reference `main` branch instead of `master`
   - Added requirements for approvals and CI checks

4. **Updated README** (`README.md`)
   - Added note about branch protection in the Contributing section
   - Links to the branch protection documentation

## How to Apply Branch Protection

After merging this PR, you need to apply the branch protection ruleset via GitHub's web interface:

### Steps:

1. **Go to Repository Settings**
   - Navigate to your repository on GitHub
   - Click on "Settings" tab

2. **Access Rulesets**
   - In the left sidebar, click "Rules" → "Rulesets"

3. **Create New Ruleset**
   - Click "New ruleset" → "New branch ruleset"

4. **Configure the Ruleset**
   - **Ruleset Name**: `Protect Main Branch`
   - **Enforcement status**: Active
   - **Target branches**: 
     - Click "Add target" → "Include by pattern"
     - Enter: `main`

5. **Add Branch Protection Rules**
   
   Enable the following rules:
   
   ✅ **Require a pull request before merging**
   - Required approving reviews: `1`
   - Dismiss stale pull request approvals when new commits are pushed: `Optional`
   - Require review from Code Owners: `Optional`
   
   ✅ **Require status checks to pass**
   - Click "Add checks"
   - Search for and add: `analyze-and-test`
   - Require branches to be up to date before merging: `Optional`

6. **Bypass Rules (Optional)**
   - If you want certain users or teams to bypass these rules, add them under "Bypass list"
   - **Recommendation**: Keep this empty for maximum security

7. **Save the Ruleset**
   - Click "Create" at the bottom

### Alternative: Use the Configuration File

The `.github/rulesets/main-branch-protection.json` file contains the exact configuration. You can:
- Use it as a reference when setting up the ruleset manually
- Use the GitHub API to programmatically apply it (see documentation)

## Verification

After applying the ruleset, verify it's working:

1. Try to push directly to main:
   ```bash
   git checkout main
   echo "test" >> test.txt
   git add test.txt
   git commit -m "Test direct push"
   git push origin main
   ```
   
   **Expected result**: Push should be rejected with an error message

2. Create a pull request and verify:
   - ✅ You cannot merge without an approval
   - ✅ You cannot merge if CI checks fail
   - ✅ You can merge after approval and passing checks

## Benefits

- 🛡️ **Code Quality**: All changes are reviewed before merging
- 🔍 **CI Integration**: Ensures tests pass before merging
- 🚫 **Prevents Accidents**: No accidental direct pushes to main
- 📝 **Audit Trail**: All changes tracked through pull requests
- 👥 **Collaboration**: Encourages code review and discussion

## Support

If you encounter any issues setting up branch protection:

1. Check the [BRANCH_PROTECTION.md](.github/BRANCH_PROTECTION.md) documentation
2. Refer to [GitHub's Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets)
3. Open an issue in this repository

## Notes

- The ruleset file is provided as a reference; GitHub rulesets must be configured through the web interface or API
- Make sure the CI workflow (`ci.yml`) is working properly before enforcing status checks
- Consider adjusting the number of required approvals based on your team size
