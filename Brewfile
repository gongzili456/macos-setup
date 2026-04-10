# macos-setup Brewfile
# 工具链清单：AI Agent 友好 = 工具链完备
# 使用方式：brew bundle install --file=Brewfile

# ─────────────────────────────────────────
# Core CLI Tools (AI Agent 必需)
# ─────────────────────────────────────────
brew "git"
brew "curl"
brew "wget"
brew "jq"
brew "ripgrep"
brew "fd"
brew "fzf"
brew "bat"
brew "eza"
brew "gh"

# ─────────────────────────────────────────
# Shells & Environment
# ─────────────────────────────────────────
brew "zsh"
brew "fish"
brew "starship"
brew "atuin"               # shell 历史增强
brew "zoxide"             # 智能 cd

# ─────────────────────────────────────────
# Runtime Version Managers
# ─────────────────────────────────────────
brew "mise"
# Python/Go/Node 等通过 mise 管理：mise install python go node
# 不在这里用 brew/pyenv/goenv 重复装

# ─────────────────────────────────────────
# Development Tools
# ─────────────────────────────────────────
brew "neovim"
brew "lazygit"
brew "git-delta"
brew "pre-commit"          # 需配合 .pre-commit-config.yaml 使用才生效
brew "pnpm"
brew "act"                 # 本地运行 GitHub Actions

# Kubernetes
brew "kubectl"
brew "kubectx"
brew "k9s"
brew "kubie"
brew "stern"

# 协议 / 网络
brew "httpie"
brew "yq"

# ─────────────────────────────────────────
# macOS-specific Tools
# ─────────────────────────────────────────
cask "ghostty"             # 终端（macOS 独占）
cask "rectangle"
cask "karabiner-elements"
cask "mas"                  # App Store CLI（用于 mas install）

# ─────────────────────────────────────────
# AI / LLM 工具
# ─────────────────────────────────────────
cask "ollama"
cask "claude-code"
cask "cursor"
cask "chatgpt"
cask "codex-app"
cask "linear-linear"

# ─────────────────────────────────────────
# Development Apps
# ─────────────────────────────────────────
cask "visual-studio-code"
cask "zed"
cask "arc"
cask "orbstack"            # Docker/K8s 运行时（macOS），colima 的替代方案
cask "devutils"            # $200+ 付费套件：SQLite/Firebase/MongoDB/Redis 查看器等
cask "bruno"
cask "dbeaver-community"
cask "android-studio"
cask "bitwarden"

# ─────────────────────────────────────────
# Design & Productivity
# ─────────────────────────────────────────
cask "figma"
cask "obsidian"
cask "notion"
cask "raycast"

# ─────────────────────────────────────────
# Utilities
# ─────────────────────────────────────────
brew "tree"
brew "ncdu"
brew "htop"
brew "watch"
brew "tldr"
brew "pkg-config"
brew "openssl@3"
brew "sqlite"

# ─────────────────────────────────────────
# Communication
# ─────────────────────────────────────────
cask "telegram"
cask "discord"
cask "feishu"
cask "wechat"
cask "windows-app"

# ─────────────────────────────────────────
# Other Apps
# ─────────────────────────────────────────
cask "google-chrome"
cask "iina"
cask "snipaste"
cask "betterdisplay"
cask "keycastr"
cask "proxyman"
cask "tailscale-app"
