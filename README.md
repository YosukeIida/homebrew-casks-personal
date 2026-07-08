# homebrew-casks-personal

Personal Homebrew tap for casks that don't have (or don't fit) an official
`homebrew/cask` entry — either the app itself is unofficial, or it's an
official app whose Homebrew packaging isn't (yet) upstreamed.

```
brew tap yosukeiida/casks-personal
brew install --cask <name>
```

## Casks

| Cask | What it is |
|---|---|
| `zed-dev-ratex` | Personal Zed fork (dev channel) with inline LaTeX/RaTeX math rendering |
| `claude-science` | Anthropic's Claude Science desktop app (rolling dev build, no official cask yet) |
| `pindrop` | Menu bar dictation app ([watzon/pindrop](https://github.com/watzon/pindrop)) |
| `powerglance` | Menu bar power/battery info app ([YosukeIida/PowerGlance](https://github.com/YosukeIida/PowerGlance)) |
| `nimbus` | Browser for Claude Code workflows ([syllogismos/nimbus](https://github.com/syllogismos/nimbus)) |

Managed declaratively from [dotfiles](https://github.com/YosukeIida/dotfiles)
via `nix/profiles/darwin/homebrew.nix`.
