# Release Guide

Quick reference for releasing new versions.

## Release Process

```bash
# 1. Make sure main is ready
git checkout main && git pull

# 2. Tag and push
git tag v1.0.1
git push origin v1.0.1

# 3. Create release on GitHub
# → Go to releases, select tag, add notes, publish
# → GitHub Actions auto-updates the tap ✨
```

That's it!

## Version Numbers

- **Patch** (1.0.X) - Bug fixes
- **Minor** (1.X.0) - New features
- **Major** (X.0.0) - Breaking changes

## Release Notes Template

```markdown
## What's Changed

- Fixed thing (#12)
- Added feature (#15)
- Improved other thing

**Full Changelog**: https://github.com/madusha98/phpswitch/compare/v1.0.0...v1.0.1

## Install/Upgrade

```bash
brew upgrade phpswitch
```

Thanks to @contributor! 🎉
```

## Merging PRs

Before merging:
- ✅ Review code
- ✅ Test if needed
- ✅ Check for breaking changes

Then: Click "Squash and merge" on GitHub

## Troubleshooting

**Workflow failed?**
1. Check Actions tab for error
2. Re-run workflow, or
3. Manual fix:
   ```bash
   cd homebrew-phpswitch
   # Edit Formula/phpswitch.rb manually
   git commit -am "Update to vX.X.X"
   git push
   ```

**Token expired?**
Regenerate at: Settings → Developer settings → Personal access tokens

---

**Need more?** Check GitHub Actions logs or workflow file.
