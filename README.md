# Personal tmux config

Minimal, macOS-focused tmux configuration with sane defaults, Vim-style keybindings, true-color support, and plugin management via **TPM**.

---

## Requirements

- **macOS**
- `tmux`
- `git`

If `tmux` or `git` are missing, they will be installed automatically via **Homebrew** (if available).

---

## Installation

```sh
curl -fsSL https://github.com/bosha/tmuxconf/install.sh | sh
```

---

## Key bindings (highlights)

### Prefix
- Prefix: Ctrl-s

### Panes
- Split horizontal: |
- Split vertical: -
- Move: h j k l
- Resize: Ctrl-s + h j k l
- Zoom pane: m

### Windows
- New window: c
- Next / prev: Meta-n / Meta-p

### Misc
- Reload config: r
- Toggle synchronized panes: S
- Kill session: K
