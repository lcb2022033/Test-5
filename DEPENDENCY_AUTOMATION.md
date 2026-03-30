# Dependency Upgrade Automation Guide

This document explains how the dependency upgrade automation system works and how to use it.

## Overview

The system consists of multiple components that work together to handle Dependabot PRs:

```
Dependabot PR Created
         ↓
  gem-upgrade-review.yml (automatic)
         ↓
  - Analyzes gem changes (gem_diff.rb)
  - Posts summary comment on PR
  - Triggers next workflow via comment
         ↓
  deps_find_usages.yml (triggered by comment)
         ↓
  - Finds where gems are used (deps_find_usages.rb)
  - Gets LLM suggestions (deps_llm_suggestions.rb)
  - Formats changelog entry (format_changelog_entry.rb)
  - Posts suggestions as PR comment
  - Commits TODO comments and suggestions
```

## Workflows

### 1. Gem Upgrade Review (Automatic)

**File:** `.github/workflows/gem-upgrade-review.yml`

**Trigger:** On any Dependabot PR that modifies Gemfile/Gemfile.lock

**What it does:**
1. Fetches the base branch (main) Gemfile.lock
2. Compares with the PR's Gemfile.lock
3. Identifies which gems changed and categorizes by risk level
4. Posts a summary table on the PR
5. Automatically triggers the next workflow

**Key Outputs:**
- `gem_review.md` - Summary of all gem changes with risk assessment

### 2. Find Usages & LLM Suggestions

**File:** `.github/workflows/deps_find_usages.yml`

**Trigger:** When a comment contains `/deps-find-usages` (automatic from previous workflow)

**What it does:**
1. Extracts changed gem names from gem_review.md
2. Scans Ruby source files for usages of those gems
3. Inserts TODO comments in files that use changed gems
4. Calls Gemini API for code update suggestions
5. Formats suggestions into changelog entry
6. Posts detailed suggestions as comment
7. Commits all changes with explanatory message

**Key Outputs:**
- `deps_usages.md` - Table of where each gem is referenced
- `gemini_suggestions.md` - Code change suggestions from LLM
- Updated `docs/dependency-upgrades-changelog.md` - Changelog entry
- TODO comments in source files - Mark areas that need review

## Scripts

### gem_diff.rb

**Purpose:** Analyze gem version changes

**Key Functions:**
- `parse_lock()` - Parse Gemfile.lock using Bundler
- `bump_type()` - Classify change as major/minor/patch/added/removed
- `risk_level()` - Determine risk based on change type and scope (runtime vs test)

**Environment Variables:**
- `GITHUB_BASE_REF` - Base branch (default: "main")
- `GEM_REVIEW_PATH` - Output file path (default: "gem_review.md")
- `PR_GEMFILE_LOCK_PATH` - Path to PR's Gemfile.lock (provided by workflow)

### deps_find_usages.rb

**Purpose:** Find gem usages and insert TODO comments

**Key Functions:**
- `changed_gems_from_review()` - Parse gem names from gem_review.md
- `ruby_source_files()` - Find all .rb/.rake/.ru files
- `find_usages()` - Search files for gem references
- `insert_todo_comments()` - Add TODO comments to files

**Output Files:**
- `deps_usages.md` - Markdown table of usages by gem and file

### deps_llm_suggestions.rb

**Purpose:** Get AI-powered code change suggestions

**Prompt Template:**
1. Includes gem_review.md (what changed)
2. Includes deps_usages.md (where it's used)
3. Asks for concrete code changes with before/after snippets
4. Asks for changelog entries

**Requirements:**
- `GEMINI_API_KEY` secret must be configured in GitHub
- Uses Gemini 1.5 Flash model

**Output Files:**
- `gemini_suggestions.md` - Formatted markdown with suggestions

### format_changelog_entry.rb

**Purpose:** Create/update changelog with upgrade information

**Process:**
1. Reads gem_review.md for version information
2. Reads gemini_suggestions.md for change descriptions
3. Creates a changelog entry with timestamp
4. Prepends to docs/dependency-upgrades-changelog.md
5. Saves summary JSON for tracking

**Output Files:**
- Updated `docs/dependency-upgrades-changelog.md`
- `.github/.changelog-summary.json` - Metadata about the update

## How to Use

### Automatic Flow

1. **Wait for Dependabot PR** - Dependabot opens a PR with updated Gemfile/Gemfile.lock
2. **Review automatically appears** - gem-upgrade-review.yml runs automatically:
   - Posts gem change summary as comment
   - Automatically triggers next step
3. **Get suggestions** - deps_find_usages.yml runs:
   - Posts where gems are used
   - Posts code suggestions
   - Commits TODO comments
4. **Follow suggestions** - Manually implement:
   - Apply code changes from suggestions
   - Test thoroughly
   - Add additional changes as needed

### Manual Workflow (if needed)

If the automatic second workflow doesn't trigger, you can manually run it:

1. Go to PR comments
2. Write: `/deps-find-usages`
3. The workflow will run immediately

## Configuration

### Required GitHub Secrets

Add these to your repository settings:

1. **GEMINI_API_KEY** - Get from [Google AI Studio](https://aistudio.google.com/app/apikey)
   - Use the API key for Gemini models
   - Add as a repository secret

### Optional Environment Variables

In workflow files, you can customize:

- `GEM_REVIEW_PATH` - Where to write gem analysis (default: "gem_review.md")
- `CHANGELOG_PATH` - Where changelog lives (default: "docs/dependency-upgrades-changelog.md")
- `MODEL` - Gemini model to use (default: "gemini-1.5-flash-latest")

## Interpreting Results

### Risk Levels

- **High Risk**: Major version changes in runtime dependencies
  - May break functionality, requires thorough testing
  - Likely needs code updates
  
- **Medium Risk**: Minor version changes in runtime OR major/minor in test dependencies
  - Probably OK but verify functionality still works
  - May need small updates
  
- **Low Risk**: Patch version changes
  - Usually backward compatible
  - Typically no code changes needed

### TODO Comments

Files with changed gem usages get comments like:

```ruby
# TODO(deps): Review usages of 'devise' in this file for version-specific changes.
```

This helps you quickly find areas that might need updates.

### Suggestions Quality

The LLM suggestions:
- ✅ Are good starting points
- ✅ Include code examples
- ⚠️ May need tweaking for your specific code
- ⚠️ Should always be tested
- ❌ Should not be applied blindly

## Best Practices

### Before Merging Dependabot PR

1. ✅ Review the gem-upgrade-review comment
2. ✅ Check risk levels - prioritize high-risk updates
3. ✅ Read gemini_suggestions.md
4. ✅ Implement suggested code changes
5. ✅ Run full test suite
6. ✅ Test manually in dev environment
7. ✅ Check changelog entry is accurate

### For High-Risk Updates

1. Create a draft PR with code changes first
2. Run CI/CD to catch issues early
3. Test all affected features manually
4. Consider breaking it into multiple PRs if complex

### Dependency-Specific Checks

- **Rails/ActiveRecord**: Test DB migrations, model associations
- **Devise**: Test sign-in, sign-up, password reset flows
- **Rack/HTTP**: Test request/response handling
- **Bundler/Ruby**: Verify all gems still resolve correctly

## Troubleshooting

### Workflow doesn't trigger second step

**Problem:** gems changes detected but no `/deps-find-usages` comment appears

**Solution:**
- Check token permissions in workflow
- Manually add `/deps-find-usages` comment to trigger

### Gemini API returns errors

**Problem:** LLM suggestions show API error

**Solutions:**
- Verify GEMINI_API_KEY is set correctly
- Check API key is valid and has usage quota
- Check network connectivity in Actions
- Try again - API may be temporarily unavailable

### TODO comments not inserted

**Problem:** Files with gem usages don't get TODO comments

**Solutions:**
- Check deps_usages.md was created
- Verify gem names match between gem_review.md and source files
- Manually add TODO comments for critical files

### Changelog not updating

**Problem:** docs/dependency-upgrades-changelog.md not updated

**Solutions:**
- Check format_changelog_entry.rb ran successfully
- Verify gemir_suggestions.md has content
- Check file permissions

## File Locations

```
.github/
  workflows/
    gem-upgrade-review.yml          # Main workflow
    deps_find_usages.yml            # Suggestion workflow
    ci.yml                          # Tests
  scripts/
    gem_diff.rb                     # Analyze gem changes
    deps_find_usages.rb             # Find where gems used
    deps_llm_suggestions.rb         # Get LLM suggestions
    format_changelog_entry.rb       # Update changelog
docs/
  dependency-upgrades-changelog.md  # The changelog file
```

## See Also

- [Dependabot Documentation](https://docs.github.com/en/code-security/dependabot)
- [Gemini API Documentation](https://ai.google.dev/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
