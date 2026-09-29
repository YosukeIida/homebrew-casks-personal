# homebrew-casks-personal

Personal Homebrew tap for casks that don't have (or don't fit) an official
`homebrew/cask` entry — either the app itself is unofficial, it's an official
app whose Homebrew packaging isn't (yet) upstreamed, or the official cask has a
problem this tap works around.

```
brew tap yosukeiida/casks-personal
brew install --cask <name>
```

## Casks

| Cask | What it is |
|---|---|
| `codex` | OpenAI Codex CLI — the official cask plus a quarantine fix (see below) |
| `zed-dev-ratex` | Personal Zed fork (dev channel) with inline LaTeX/RaTeX math rendering |
| `claude-science` | Anthropic's Claude Science desktop app (rolling dev build, no official cask yet) |
| `pindrop` | Menu bar dictation app ([watzon/pindrop](https://github.com/watzon/pindrop)) |
| `powerglance` | Menu bar power/battery info app ([YosukeIida/PowerGlance](https://github.com/YosukeIida/PowerGlance)) |
| `nimbus` | Browser for Claude Code workflows ([syllogismos/nimbus](https://github.com/syllogismos/nimbus)) |

Managed declaratively from [dotfiles](https://github.com/YosukeIida/dotfiles)
via `nix/profiles/darwin/homebrew.nix`. Nothing here depends on Nix.

## `codex`: `brew upgrade` stuck on a Gatekeeper dialog

### Symptom

On macOS, `brew upgrade` stops partway through upgrading the official `codex`
cask, and a dialog appears on the Mac's screen:

> "codex" is an app downloaded from the Internet. Are you sure you want to open it?

The upgrade waits until someone clicks **Open** in the GUI. Over SSH there is
nothing to click, so it just hangs (`ps` shows `.../Caskroom/codex/<ver>/bin/codex completion bash`).

### Cause

1. Homebrew marks every cask download with the `com.apple.quarantine` attribute
   and copies it onto every extracted file.
2. The official `codex` cask runs `bin/codex completion` during install to
   generate shell completions. That is the first time the new binary is
   executed, so Gatekeeper asks for approval right there, inside `brew upgrade`.

There is no user-side opt-out. `--no-quarantine` and `HOMEBREW_CASK_OPTS` no
longer exist in Homebrew 7, and removing the attribute from the cached download
does not help (Homebrew adds it back every time it reuses the cache).

### Fix

This tap's `codex` is the official cask plus a `preflight_steps` block that
clears the attribute. Preflight steps run after extraction but before
`binary` and `generate_completions_from_executable`, so neither the upgrade nor
the first launch shows the dialog. The payload is unchanged: the cask points at
the same `openai/codex` GitHub release tarball.

```
brew uninstall --cask codex
brew install --cask yosukeiida/casks-personal/codex
```

After that, plain `brew upgrade` picks it up. `version` and `sha256` are bumped
every 6 hours by `.github/workflows/bump-codex.yml`, using the SHA-256 digests
that GitHub publishes for the release assets. Unlike `homebrew/cask`, those
bumps are not reviewed by a person; you are trusting the upstream release and
this workflow.

### Claude Code (not in this tap)

The official `claude-code` / `claude-code@latest` cask never runs `claude`
during install, so `brew upgrade` does not hang. The dialog still appears the
first time you launch `claude` after each upgrade, which also blocks over SSH.
Clear the attribute before launching:

```
xattr -d com.apple.quarantine "$(readlink -f "$(command -v claude)")"
```
