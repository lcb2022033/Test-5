# ✅ Dependency Automation Setup Checklist

Use this checklist to ensure the dependency upgrade automation is fully configured.

## GitHub Repository Setup

- [ ] Repository has Dependabot enabled
  - Go to Settings → Code security & analysis
  - Enable "Dependabot version updates"

- [ ] Dependabot is configured for bundle
  - Check `.github/dependabot.yml` exists
  - It should have a bundler entry

- [ ] GitHub Actions is enabled
  - Settings → Actions → General
  - "Actions permissions" is set to allow workflows

- [ ] `GEMINI_API_KEY` secret is configured
  - Go to Settings → Secrets and variables → Actions
  - Create new secret: `GEMINI_API_KEY`
  - Value: Your Google AI API key from https://aistudio.google.com/app/apikey

## Files in Place

Core workflow files:
- [ ] `.github/workflows/gem-upgrade-review.yml` - Main review workflow
- [ ] `.github/workflows/deps_find_usages.yml` - Suggestion & commit workflow
- [ ] `.github/workflows/ci.yml` - CI tests (existing)

Core scripts:
- [ ] `.github/scripts/gem_diff.rb` - Analyzes gem changes
- [ ] `.github/scripts/deps_find_usages.rb` - Finds where gems are used
- [ ] `.github/scripts/deps_llm_suggestions.rb` - Gets LLM suggestions
- [ ] `.github/scripts/format_changelog_entry.rb` - Updates changelog
- [ ] `.github/scripts/organize_suggestions.rb` - Organizes suggestions

Documentation files:
- [ ] `DEPENDENCY_AUTOMATION.md` - Full guide
- [ ] `docs/dependency-upgrades-changelog.md` - Changelog template
- [ ] `docs/DEPENDENCY_UPGRADE_QUICKREF.md` - Quick reference
- [ ] `README.md` - Updated with automation info

## Testing the Setup

### Test Dependabot itself
```bash
# Create a test branch
git checkout -b test-dependabot

# Manually bump a gem in Gemfile to test
# For example, change devise version to something older
# like devise "~> 4.8.0"

# Commit and push
git add Gemfile
git commit -m "test: bump devise version"
git push origin test-dependabot

# Create a PR to see if workflows trigger
# (On GitHub, create PR from test-dependabot to main)

# Clean up after test
git checkout main
git branch -D test-dependabot
git push origin --delete test-dependabot
```

### Verify gem-upgrade-review workflow
- [ ] Dependabot PR opens
- [ ] After 1-2 minutes, a comment appears with gem summary
- [ ] Comment shows table with gem changes
- [ ] Comment mentions next workflow will trigger

### Verify deps_find_usages workflow
- [ ] A few minutes after first comment, another comment appears
- [ ] Second comment has code suggestions
- [ ] Check if TODO comments were added (git diff on PR)
- [ ] Check if changelog was updated

## Troubleshooting Setup

### Workflows don't appear in Actions tab
**Solution:**
- Repository might be forked - workflows need enabling
- Go to Actions tab → "I understand..." button
- Click to enable workflows

### GEMINI_API_KEY not working
**Solution:**
- Verify key is valid: test it at https://aistudio.google.com/app/apikey
- Make sure secret name is exactly `GEMINI_API_KEY` (case-sensitive)
- Verify secret is available to this repository

### Scripts fail with "command not found"
**Solution:**
- Check Ruby version in workflow matches system: `ruby -v`
- Verify bundler is installed: `gem list bundler`
- Manually run script to check: `cd /repo && ruby .github/scripts/gem_diff.rb`

### No comment appears on Dependabot PR
**Possible causes:**
1. Workflow didn't trigger
   - Check Actions tab → gem-upgrade-review
   - Look for error logs
   
2. Workflow succeeded but comment failed
   - Check "Comment on PR with dependency summary" step
   - Verify token permissions
   
3. Base branch doesn't have Gemfile.lock
   - Ensure main branch has Gemfile.lock committed

**Solution steps:**
```bash
# Check locally first
cd repo
git checkout main
ruby .github/scripts/gem_diff.rb

# This should create gem_review.md without errors
cat gem_review.md
```

## Security Checklist

- [ ] `GEMINI_API_KEY` is marked as secret (not visible in logs)
- [ ] Workflows check for `dependabot[bot]` as actor
- [ ] Workflows don't expose sensitive data in comments
- [ ] GitHub Actions permissions are minimal necessary
  - gem-upgrade-review: `contents: read, pull-requests: write`
  - deps_find_usages: `contents: write, pull-requests: write`

## Performance Considerations

- [ ] Workflows don't run on every commit (only Dependabot PRs)
- [ ] Scripts use efficient file searching (avoid full binary searches)
- [ ] LLM API calls are rate-limited
- [ ] Changelog doesn't get too large (consider archiving old entries)

## Maintenance

### Monthly Tasks
- [ ] Review workflow execution logs for errors
- [ ] Check if any Dependabot PRs failed
- [ ] Verify changelog entries make sense

### Quarterly Tasks
- [ ] Review GEMINI_API_KEY usage and limits
- [ ] Update documentation if workflows change
- [ ] Test manual workflow trigger: `/deps-find-usages`

### Yearly Tasks
- [ ] Review gem security policy
- [ ] Update Ruby version in workflows if needed
- [ ] Archive old changelog entries

## Next Steps

1. ✅ Complete all checkboxes above
2. ✅ Wait for next Dependabot PR (or create test)
3. ✅ Test the full workflow end-to-end
4. ✅ Document any customizations in DEPENDENCY_AUTOMATION.md
5. ✅ Train team on process (share DEPENDENCY_UPGRADE_QUICKREF.md)

---

**Questions?** Check [DEPENDENCY_AUTOMATION.md](../DEPENDENCY_AUTOMATION.md) for detailed information.
