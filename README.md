# macos-setup

半自动 macOS 工作站初始化脚本。聚焦工具链，AI-Agent 友好，人类保持控制。

## 目标

将一台崭新的 Mac 配置为专业软件工程师工作台，核心原则：

- **Human-first**：关键步骤暂停确认，人类保持控制
- **AI-Agent Friendly**：初始化结果对 AI 编程助手友好——Git/curl/jq 等工具链完备，Agent 跑命令不会"command not found"
- **最小化**：只做工具链，不做"操作系统美化大礼包"

## 前置要求

- macOS（Apple Silicon 或 Intel）
- Xcode Command Line Tools（脚本会检测并提示安装）
- 网络连接

## 快速开始

```bash
git clone https://github.com/YOUR_USERNAME/macos-setup.git
cd macos-setup
./setup.sh
```

脚本会逐步提示，每个关键步骤等待确认。

## 工具链清单

### Core CLI（AI-Agent 必需）

| 工具 | 用途 |
|------|------|
| git | 版本控制 |
| curl | HTTP 请求 |
| jq | JSON 处理 |
| ripgrep (rg) | 代码搜索 |
| fd | 文件查找 |
| fzf | 模糊搜索 |
| bat | cat 替代品 |
| eza | ls 替代品 |
| gh | GitHub CLI |

### Shells & Environment

| 工具 | 用途 |
|------|------|
| zsh | 默认 shell |
| starship | 跨平台 prompt |
| mise | Runtime 版本管理器 |

### Utilities

| 工具 | 用途 |
|------|------|
| tree | 目录树 |
| ncdu | 磁盘分析 |
| htop | 进程监控 |
| mas | macOS App Store CLI |

## 自定义 Brewfile

编辑 `Brewfile` 添加/删除工具：

```bash
# 添加 CLI 工具
brew "vim"

# 添加 GUI 应用
cask "1password"
cask "rectangle"
```

## CI/CD 验证

GitHub Actions 在 macOS runner 上验证 Brewfile 语法：

```yaml
# .github/workflows/brewfile.yml
name: Brewfile
on: [push, pull_request]
jobs:
  validate:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - name: Validate Brewfile
        run: brew bundle check --file=Brewfile || brew bundle install --file=Brewfile
```

## 重跑 / 更新

```bash
brew bundle install --file=./Brewfile
```

`brew bundle install` 是幂等的——重复运行不会重复安装已存在的包。

## 已知限制

- App Store 应用安装需要额外的 Apple ID 认证（暂不包含）
- dotfiles 同步需要手动处理（建议单独管理 dotfiles 仓库）
- 仅支持 zsh（不使用 /bin/sh）

## 项目结构

```
macos-setup/
├── Brewfile     # 工具清单
├── setup.sh     # 交互式安装脚本
└── README.md    # 本文件
```
