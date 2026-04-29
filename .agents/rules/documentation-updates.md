---
description: "Mandatory documentation updates after every change — CHANGELOG, status, and summary"
alwaysApply: true
---

# Documentation Updates (Mandatory)

Documentation lives in `tech_readme_files/` (repository root). The changelog is at `CHANGELOG.md` (repository root).

For `.agents/`, `.claude/`, `.cursor/`, and related `*ignore` files, see **`AGENTS.md`** — **Agent tooling layout (repository root)**.

## After EVERY feature, fix, refactor, or meaningful change, you MUST update:

1. **`CHANGELOG.md`** — Add the change under the correct version's `### Added`, `### Changed`, or `### Fixed` section. Follow [Keep a Changelog](https://keepachangelog.com/) format.
2. **`tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`** — Add a dated entry at the top documenting: what changed, files created, files modified, key decisions.
3. **`tech_readme_files/CURRENT_STATUS.md`** — Update feature status, metrics, progress, and any new sections.

## Conditional updates (only when relevant):

| File | Update when… |
|------|-------|
| `01_folder_structure.md` | Adding/removing/moving files or folders |
| `02_architecture.md` | Changing architecture patterns or layers |
| `03_how_to_add_new_feature.md` | Changing the feature scaffold process |
| `04_how_to_add_new_api.md` | Changing API integration patterns |
| `05_how_to_add_new_language.md` | Adding languages or changing l10n setup |
| `06_how_to_change_theme_colors.md` | Adding design tokens or changing theme |
| `07_how_to_create_reusable_component.md` | Adding/changing shared widgets |
| `08_security_and_environment.md` | Adding secrets, changing auth/security |
| `09_api_endpoints.md` | Adding/changing API endpoints |
