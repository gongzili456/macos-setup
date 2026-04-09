#!/usr/bin/env zsh
# macos-setup: 半自动 macOS 工作站初始化脚本
# Human-first: 关键步骤暂停确认
# AI-Agent Friendly: 工具链完备

set -e

# ─────────────────────────────────────────
# Colors
# ─────────────────────────────────────────
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
RESET=$(tput sgr0)

info()    { echo "${BLUE}[INFO]${RESET} $1" }
warn()    { echo "${YELLOW}[WARN]${RESET} $1" }
error()   { echo "${RED}[ERROR]${RESET} $1" }
success() { echo "${GREEN}[OK]${RESET} $1" }
step()    { echo "${BOLD}[STEP]${RESET} $1" }

# ─────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────
confirm() {
  local prompt="$1"
  local default="${2:-Y}"
  local reply
  echo -n "${prompt} [${default}] "
  read reply
  reply=${reply:-$default}
  [[ ${reply:l} == "y" ]]
}

die() {
  error "$1"
  exit 1
}

# ─────────────────────────────────────────
# STEP 0: Check shell
# ─────────────────────────────────────────
step "检测运行环境"
if [[ ! -o interactive ]]; then
  warn "脚本可能在非交互式环境运行，部分功能可能异常"
fi
if [[ $SHELL != */zsh ]]; then
  warn "当前 shell 是 $SHELL，推荐使用 zsh: chsh -s /bin/zsh"
fi
success "Shell 检查完成"

# ─────────────────────────────────────────
# STEP 1: Check Xcode CLT
# ─────────────────────────────────────────
step "检查 Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
  warn "Xcode CLT 未安装"
  if confirm "是否运行 xcode-select --install 安装？"; then
    xcode-select --install
    info "请在弹出的窗口中完成安装，然后重新运行此脚本"
    exit 0
  else
    die "Xcode CLT 是必需的前置依赖，脚本无法继续"
  fi
else
  success "Xcode CLT 已安装"
fi

# ─────────────────────────────────────────
# STEP 2: Check/install Homebrew
# ─────────────────────────────────────────
step "检查 Homebrew"
if ! command -v brew &>/dev/null; then
  warn "Homebrew 未安装"
  if confirm "是否安装 Homebrew？"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    success "Homebrew 安装完成"
  else
    die "Homebrew 是必需的前置依赖，脚本无法继续"
  fi
else
  local brew_version=$(brew --version | head -1)
  success "Homebrew 已安装: $brew_version"
fi

# ─────────────────────────────────────────
# STEP 3: Brewfile 存在性检查
# ─────────────────────────────────────────
step "检查 Brewfile"
BREWFILE_DIR="${0:a:h}"
BREWFILE="$BREWFILE_DIR/Brewfile"
if [[ ! -f "$BREWFILE" ]]; then
  die "Brewfile 未找到: $BREWFILE"
fi
success "Brewfile 存在: $BREWFILE"

# ─────────────────────────────────────────
# STEP 4: brew update
# ─────────────────────────────────────────
step "更新 Homebrew"
info "运行: brew update"
if confirm "继续？"; then
  brew update || warn "brew update 失败，继续尝试安装"
else
  info "跳过 brew update"
fi

# ─────────────────────────────────────────
# STEP 5: brew bundle install
# ─────────────────────────────────────────
step "安装工具链"
info "Brewfile 内容预览："
echo ""
# 显示 Brewfile 前 20 行
head -20 "$BREWFILE" | sed 's/^/  /'
echo "  ..."
echo ""
success "共 $(grep -c "^brew \|^cask " "$BREWFILE") 个包待安装"
echo ""

if confirm "运行 brew bundle install --file=\"$BREWFILE\"？"; then
  info "开始安装（可能需要 10-30 分钟）..."
  brew bundle install --file="$BREWFILE" --verbose || {
    error "brew bundle install 失败，退出。请检查上方输出。"
    exit 1
  }
  success "工具链安装完成"
else
  info "已取消。你可以手动运行：brew bundle install --file=\"$BREWFILE\""
fi

# ─────────────────────────────────────────
# STEP 6: Verify AI-Agent essentials
# ─────────────────────────────────────────
step "验证工具链"
# 从 Brewfile 动态提取所有 brew 条目（不含 cask，cask 是 GUI app）
AGENT_TOOLS=($(grep "^brew " "$BREWFILE" | awk '{print $2}' | sort))
info "从 Brewfile 提取 ${#AGENT_TOOLS[@]} 个 CLI 工具待验证"
all_ok=true
failed_tools=()
for tool in $AGENT_TOOLS; do
  if command -v $tool &>/dev/null; then
    success "$tool: $(command -v $tool)"
  else
    error "$tool: 未找到"
    all_ok=false
    failed_tools+=($tool)
  fi
done

echo ""
if $all_ok; then
  success "所有 AI-Agent 必需工具已就绪"
else
  error "以下工具缺失：${failed_tools[*]}"
  error "脚本失败。请检查 brew bundle install 的输出。"
  exit 1
fi

# ─────────────────────────────────────────
# STEP 7: shell 配置提示
# ─────────────────────────────────────────
step "Shell 环境配置"
if confirm "是否将 starship 添加到 ~/.zshrc？"; then
  if command -v starship &>/dev/null; then
    if grep -q 'eval "$(starship init zsh)"' ~/.zshrc 2>/dev/null; then
      info "starship 已配置"
    else
      echo 'eval "$(starship init zsh)"' >> ~/.zshrc
      success "starship 已添加到 ~/.zshrc（下次新开 terminal 生效）"
    fi
  else
    warn "starship 未安装，跳过"
  fi
fi

# ─────────────────────────────────────────
# STEP 8: mise 环境初始化
# ─────────────────────────────────────────
step "mise 环境初始化"
if command -v mise &>/dev/null; then
  info "mise 已安装: $(mise --version)"
  if confirm "是否运行 mise install 初始化开发环境？"; then
    mise install || warn "mise install 完成，部分工具可能需要额外配置"
  fi
else
  warn "mise 未安装，跳过（可通过 brew install mise 安装）"
fi

# ─────────────────────────────────────────
# Done
# ─────────────────────────────────────────
echo ""
echo "${BOLD}────────────────────────────────────────${RESET}"
success "macos-setup 完成！"
echo ""
echo "建议下一步："
echo "  1. 重启 terminal 或运行: exec zsh"
echo "  2. 验证: git --version && curl --version && jq --version"
echo "  3. 如使用 Claude Code: claude --version"
echo "  4. 个性化配置你的 ~/.zshrc 和 dotfiles"
echo ""
echo "完整重跑: brew bundle install --file=\"$BREWFILE\""
