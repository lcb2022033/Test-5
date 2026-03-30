# ⚠️ Automatic Code Modification - Important Information

## What Changed

The system now **automatically modifies your application code** based on AI suggestions when you comment `/deps-find-usages` on a Dependabot PR.

## How It Works

```
1. AI generates code suggestions (BEFORE/AFTER blocks)
        ↓
2. auto_apply_suggestions.rb runs
        ↓
3. Script searches for BEFORE code in your files
        ↓
4. Replaces with AFTER code automatically
        ↓
5. Reports what was changed
        ↓
6. Changes are committed to the PR
```

## What Gets Modified Automatically

- ✅ **Application code** (.rb files)
- ✅ **Controllers** (app/controllers/*.rb)
- ✅ **Models** (app/models/*.rb)
- ✅ **Helpers** (app/helpers/*.rb)
- ✅ **Config files** (config/*.rb)
- ✅ **Any Ruby file** where matching code is found

## Safety Features

1. **Exact matching first**: Looks for exact code match
2. **Fuzzy matching second**: Strips whitespace and tries again
3. **Reports failures**: Shows what couldn't be applied
4. **One occurrence per change**: Only replaces first match found
5. **Skips vendor/**: Doesn't touch third-party code

## ⚠️ Risks and Warnings

### 🔴 High Risk Scenarios

1. **AI suggestions might be wrong**
   - The AI doesn't run your tests
   - It doesn't understand your full context
   - Suggestions are best-effort, not guaranteed correct

2. **Code might break**
   - Automatic replacements could introduce bugs
   - Edge cases might not be handled
   - Context might be misunderstood

3. **Multiple similar code patterns**
   - If you have similar code in multiple places
   - Only the first match gets replaced
   - Other instances need manual fixes

4. **Incomplete changes**
   - AI might not catch all affected code
   - Related changes in other files might be missed
   - Configuration changes might be needed

### 🟡 Medium Risk Scenarios

1. **Whitespace differences**: Fuzzy matching helps but isn't perfect
2. **Code formatting**: Might change your formatting style
3. **Comments**: Inline comments might be lost/changed

## Best Practices

### ✅ DO:

- **Review EVERY auto-applied change** before merging
- **Run your full test suite** after changes
- **Test manually** in development environment
- **Check the PR diff** carefully
- **Read the gemini_suggestions.md** to understand what changed
- **Keep backups** of important code

### ❌ DON'T:

- **Blindly merge** the PR after auto-apply
- **Skip testing** - always test!
- **Ignore failed auto-applies** - review them manually
- **Deploy directly to production** - test first!

## How to Review Auto-Applied Changes

1. **Go to the PR on GitHub**
2. **Click "Files changed" tab**
3. **Look for modified .rb files**
4. **Review each change:**
   - Does it make sense?
   - Is it related to the gem upgrade?
   - Could it break existing functionality?
5. **Check the auto-apply summary** in workflow logs

## If Something Goes Wrong

### Roll back changes:
```bash
# In the PR
git revert HEAD
git push
```

### Disable auto-apply:
Remove the "Auto-apply code suggestions" step from `.github/workflows/deps_find_usages.yml`

### Manual fixes:
1. Read `gemini_suggestions.md`
2. Apply changes manually with proper testing
3. Commit your manual fixes

## Example: What Gets Changed

### Before Auto-Apply
```ruby
# app/controllers/application_controller.rb
def after_sign_in_path_for(resource)
  dashboard_path
end
```

### After Auto-Apply (if AI suggests)
```ruby
# app/controllers/application_controller.rb
def after_sign_in_path_for(resource)
  # Updated for Devise 4.9 - now requires resource parameter usage
  user_dashboard_path(resource)
end
```

### You see in PR:
- ✅ Code was changed automatically
- ✅ Comment added explaining why
- ✅ Commit message references the gem change

## Monitoring Auto-Apply

### Check workflow logs:
1. Go to Actions tab
2. Find "Deps – Find Usages" workflow
3. Check "Auto-apply code suggestions" step
4. Review output:
   ```
   📝 Found 3 code change(s) to apply
   🔍 Change 1/3 (devise)
      ✅ Applied to: app/controllers/application_controller.rb
   🔍 Change 2/3 (rails)
      ❌ Could not find matching code in any file
   🔍 Change 3/3 (puma)
      ✅ Applied to: config/puma.rb
   
   ✅ Applied: 2
   ❌ Failed: 1
   ```

## Testing Checklist

After auto-apply runs, verify:

- [ ] All tests pass: `bundle exec rails test`
- [ ] App starts: `rails server`
- [ ] Login/logout works (if Devise changed)
- [ ] Database operations work (if ActiveRecord changed)
- [ ] Background jobs work (if Sidekiq/etc changed)
- [ ] Review each modified file manually
- [ ] Check for TODO comments that weren't auto-fixed
- [ ] Run system tests: `rails test:system`

## Disabling Auto-Apply

If you want suggestions only (no automatic changes):

1. Edit `.github/workflows/deps_find_usages.yml`
2. Remove or comment out this step:
```yaml
      # - name: Auto-apply code suggestions
      #   if: steps.check_suggestions.outputs.exists == 'true'
      #   run: ruby .github/scripts/auto_apply_suggestions.rb
```
3. Commit and push

## FAQ

**Q: Will it break my code?**
A: It might. Always test before merging.

**Q: Can I undo changes?**
A: Yes, use `git revert` or force push the original branch.

**Q: What if auto-apply fails?**
A: Check the logs, then manually apply the change from gemini_suggestions.md.

**Q: Can I review changes before they're pushed?**
A: The workflow commits automatically. Review the PR diff before merging.

**Q: Is this safe for production?**
A: Only if you thoroughly test first. Use staging environment.

**Q: What about tests?**
A: Auto-apply doesn't update tests. You may need to update them manually.

## Recommendation

### For small projects / personal projects:
✅ Auto-apply is helpful and saves time

### For production / team projects:
⚠️ Consider disabling auto-apply OR
⚠️ Require thorough review before merging
⚠️ Set up required PR reviews in GitHub settings

---

**Remember: The AI is helping, not replacing your judgment. Always review and test!** 🧠✅
