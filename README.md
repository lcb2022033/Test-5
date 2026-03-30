# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## 🔄 Dependency Upgrade Automation

This project uses an automated system to handle dependency upgrades from Dependabot:

### Quick Start
When a Dependabot PR appears:
1. Read the gem change summary (automatically posted as comment)
2. **Manually comment** `/deps-find-usages` when ready
3. **⚠️ System will automatically modify your code** based on AI suggestions
4. Review all changes, run tests, and merge

### ⚠️ IMPORTANT: Auto-Apply Feature
The system now **automatically modifies your application code** when triggered. 
- Changes are based on AI suggestions
- **Always review changes before merging!**
- **Test thoroughly** - the AI might make mistakes
- See [docs/AUTO_APPLY_WARNING.md](./docs/AUTO_APPLY_WARNING.md) for full details

### For More Information
- 📖 **Complete Guide:** [DEPENDENCY_AUTOMATION.md](./DEPENDENCY_AUTOMATION.md)
- ⚡ **Quick Reference:** [docs/DEPENDENCY_UPGRADE_QUICKREF.md](./docs/DEPENDENCY_UPGRADE_QUICKREF.md)
- 📋 **Changelog:** [docs/dependency-upgrades-changelog.md](./docs/dependency-upgrades-changelog.md)

### How It Works
```
Dependabot PR
  ↓ (automatic)
Analyze gem changes → Post summary comment
  ↓ (YOU comment /deps-find-usages)
Find usages → Get LLM suggestions → Auto-apply code changes → Update changelog
  ↓
Review auto-applied changes
  ↓
Test thoroughly & merge
```

### Required Setup
To make this work, ensure GitHub secret `GEMINI_API_KEY` is configured:
1. Get API key from [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Add to repository secrets as `GEMINI_API_KEY`
3. Enable access to this repository in the Actions


