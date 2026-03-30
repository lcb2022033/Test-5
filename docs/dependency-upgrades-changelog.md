# Dependency Upgrades Changelog

This document tracks all significant dependency upgrades and the code changes made to maintain compatibility and functionality.

## Format

Each entry documents:
- **Gems Updated**: Version changes
- **Code Changes**: What was updated in the application
- **Behavioral Changes**: Any changes to existing functionality
- **Related Issues/PRs**: Links to relevant discussions
- **Test Coverage**: Which tests verify the changes

---

## Unreleased

_(New entries will be added here automatically as Dependabot PRs are merged)_

---

## Maintenance and Updates

This changelog is automatically updated when dependency upgrade PRs are processed. See `.github/scripts/format_changelog_entry.rb` for details on how entries are generated.

### How to Update

When manually upgrading dependencies:

1. Create or update an entry below the "Unreleased" section
2. Include the deprecation notices from the gem's changelog
3. Document any breaking changes
4. Link to the commit(s) that implement the changes

### Gem-Specific Notes

#### Rails Dependencies
- Monitor ActionPack, ActiveRecord, and ActiveSupport changelogs closely
- Test all DB migrations and controller actions thoroughly
- Check for changes in route matching and parameter handling

#### Devise
- Test authentication flows after upgrades
- Review OmniAuth integration if used
- Check email confirmation workflows

#### Bundler/Ruby
- Ensure compatibility between Ruby and bundler versions
- Update CI workflows if Ruby version constraints change
