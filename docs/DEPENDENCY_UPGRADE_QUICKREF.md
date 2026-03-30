# 🚀 Dependency Upgrade Quick Reference

## The Flow (Automated)

```
1. Dependabot creates PR → 2. gem-upgrade-review.yml posts summary
                         ↓
3. Next workflow auto-triggers → 4. deps_find_usages.yml:
                                  - Finds gem usages
                                  - Gets LLM suggestions
                                  - Updates changelog
                                  - Commits changes
                         ↓
5. You review suggestions & implement changes
                         ↓
6. Test everything
                         ↓
7. Merge Dependabot PR → All set! 🎉
```

## On Each Dependabot PR, You'll See:

### Comment 1: Gem Change Summary (Auto-posted)
```
## Dependency change summary

| Gem | Old | New | Change | Risk |
|-----|-----|-----|--------|------|
| devise | 4.8.0 | 4.9.0 | minor | Medium |
| rails | 7.0.0 | 7.1.0 | minor | High |
```

- ✅ Identifies which gems changed
- 📊 Shows risk level
- ⏳ Auto-triggers next step

### Comment 2: Detailed Suggestions (Auto-posted after a few minutes)
```
## Code Changes Needed

### devise

The new version changes X callback...

**BEFORE:**
```ruby
# old code
```

**AFTER:**
```ruby
# new code
```
```

- 💡 Actual code changes needed
- 🔗 Links to changelogs
- 📝 Explains what changed

## Your Checklist

### For Each Dependabot PR:

- [ ] Read the gem change summary (Comment 1)
- [ ] Check the risk levels
  - High risk → needs careful testing
  - Medium risk → test affected features
  - Low risk → probably fine
- [ ] Read detailed suggestions (Comment 2)
- [ ] Open the modified files:
  - TODO comments show where gems are used
  - Compare with gemini_suggestions.md
- [ ] Apply suggested code changes
- [ ] Run tests: `bundle exec rails test`
- [ ] Test in browser if it's UI-related
- [ ] Approve & merge when ready

## Common Risk Scenarios

### 🔴 High Risk (Major version change in Rails/Devise/DB)

**Examples:** Rails 6→7, Devise 4→5, PostgreSQL driver major bump

**What to do:**
1. ✅ Read CHANGELOG carefully
2. ✅ Check breaking changes section
3. ✅ Run full test suite multiple times
4. ✅ Test all auth flows manually
5. ✅ Check database compatibility

### 🟡 Medium Risk (Minor version change in runtime gem)

**Examples:** Rails 7.0→7.1, Devise 4.8→4.9

**What to do:**
1. ✅ Review suggestion comments
2. ✅ Run test suite
3. ✅ Test main features

### 🟢 Low Risk (Patch version change)

**Examples:** Rails 7.1.1→7.1.2, dependency patches

**What to do:**
1. ✅ Merge (usually safe)
2. ✅ Light testing if you have time

## Key Files

| File | Purpose |
|------|---------|
| `gem_review.md` | Gem change summary (auto-generated) |
| `deps_usages.md` | Where gems used (auto-generated) |
| `gemini_suggestions.md` | Code changes needed (auto-generated) |
| `docs/dependency-upgrades-changelog.md` | Permanent changelog |
| `.github/scripts/` | Automation scripts |

## If Something Goes Wrong

### "I want to trigger suggestions manually"
Comment on the PR: `/deps-find-usages`

### "Workflow failed"
Check GitHub Actions tab → click failed workflow → read logs

### "I don't understand a suggestion"
- Read the linked changelog
- Ask Claude/ChatGPT to explain
- Check the BEFORE/AFTER code diff

### "Tests are failing"
1. Read error message
2. Check if it matches a suggestion
3. Apply the suggested fix
4. Run tests again

## Copilot Integration

You can ask GitHub Copilot about suggestions while in VS Code:

### Ask Copilot to:
- "Explain this gem change"
- "How do I apply this suggestion?"
- "What tests should I run?"
- "Are there other places using this gem?"

Just mention the gem name and Copilot can help!

## Testing Tips

### After applying changes:

```bash
# Run specific test related to the gem
bundle exec rails test test/models/user_test.rb

# Run all tests
bundle exec rails test

# Run specific test
bundle exec rails test:system   # for browser tests

# Check Rails console works
rails console
```

### Test gem integrations manually:

```ruby
# In rails console
User.create(email: "test@example.com", password: "password")
# If Devise was updated, auth should work

User.find_by(email: "test@example.com").valid_password?("password")
```

## Troubleshooting Specific Gems

### Rails/ActiveRecord
- ❌ Models don't load? Check associations syntax
- ❌ DB migration issues? Run `rails db:rollback` then `rails db:migrate`
- ❌ Routing issues? Check route matching syntax

### Devise
- ❌ Sign-in broken? Check authentication callbacks
- ❌ Email not sending? Check mailer config
- ❌ Password reset failing? Check token generation

### Other gems
- 📖 Always check CHANGELOG.md in gem repo
- 🧪 Run the gem's tests: `bundle exec rake`
- 🔗 Check their documentation for breaking changes

## Useful Commands

```bash
# See what's different from main
git diff main Gemfile.lock

# See gem versions
bundle list

# Check specific gem version
bundle list | grep devise

# Update a specific gem (if needed)
bundle update devise

# Check what changed in changelog
# (Usually on github.com/gem-owner/gem-name/CHANGELOG.md)
```

## When You're Done

1. ✅ All changes applied
2. ✅ Tests passing
3. ✅ Manual testing done
4. ✅ Approve the PR
5. ✅ Merge the PR
6. ✅ Confirm deploy successful

---

**Need more details?** See [DEPENDENCY_AUTOMATION.md](../DEPENDENCY_AUTOMATION.md)
