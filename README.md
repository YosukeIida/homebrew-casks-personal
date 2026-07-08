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

Managed declaratively from [dotfiles](https://github.com/YosukeIida/dotfiles)
via `nix/profiles/darwin/homebrew.nix`.
