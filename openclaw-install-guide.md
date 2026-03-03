# OpenClaw 详细安装指南

> 🦞 OpenClaw 是一个自托管的 AI 网关，连接 WhatsApp、Telegram、Discord、iMessage 等聊天应用到 AI 助手

**文档版本**: v1.0  
**最后更新**: 2026 年 3 月 3 日  
**OpenClaw 版本**: 2026.3.1

---

## 📋 目录

1. [系统要求](#系统要求)
2. [快速安装（推荐）](#快速安装推荐)
3. [安装方法详解](#安装方法详解)
4. [首次配置](#首次配置)
5. [启动网关](#启动网关)
6. [连接聊天渠道](#连接聊天渠道)
7. [验证安装](#验证安装)
8. [常见问题](#常见问题)
9. [高级配置](#高级配置)

---

## 系统要求

### 硬件要求
- **CPU**: 任意现代处理器（Intel/AMD/ARM）
- **内存**: 最低 2GB，推荐 4GB+
- **存储**: 最低 1GB 可用空间
- **网络**: 需要访问互联网（API 调用、npm 等）

### 软件要求
- **Node.js**: 22 或更高版本
- **操作系统**: 
  - macOS 10.15+
  - Linux（Ubuntu 20.04+、Debian 10+、CentOS 8+ 等）
  - Windows 10+（推荐使用 WSL2）
- **Git**: 用于某些安装方法
- **pnpm**: 仅当从源码构建时需要

<details>
<summary>💡 检查系统环境</summary>

```bash
# 检查 Node.js 版本
node --version

# 检查 npm 版本
npm --version

# 检查 Git 是否安装
git --version

# 检查操作系统
uname -a  # macOS/Linux
ver       # Windows
```

</details>

---

## 快速安装（推荐）

### 方法一：安装脚本（最简单）

这是官方推荐的安装方式，自动处理 Node.js 安装、OpenClaw 安装和初始化配置。

#### macOS / Linux / WSL2

```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

#### Windows (PowerShell)

```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

**安装脚本会自动：**
1. ✅ 检测并安装 Node.js 22+（如果缺失）
2. ✅ 安装 Git（如果缺失）
3. ✅ 通过 npm 安装 OpenClaw
4. ✅ 启动配置向导

<details>
<summary>🔧 安装脚本选项</summary>

```bash
# 跳过配置向导，仅安装
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard

# 使用 git 方式安装（适合开发者）
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --install-method git

# 指定版本
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --version 2026.3.1

# 安装 beta 版本
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --beta

# 干运行（查看会做什么但不执行）
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --dry-run

# 详细输出（调试用）
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --verbose
```

</details>

---

## 安装方法详解

### 方法一：npm/pnpm 安装

如果你已经安装了 Node.js 22+，可以直接使用 npm 或 pnpm 安装。

#### 使用 npm

```bash
# 安装 OpenClaw
npm install -g openclaw@latest

# 如果遇到 sharp 构建错误（macOS 常见）
SHARP_IGNORE_GLOBAL_LIBVIPS=1 npm install -g openclaw@latest

# 安装完成后运行配置向导
openclaw onboard --install-daemon
```

#### 使用 pnpm

```bash
# 安装 OpenClaw
pnpm add -g openclaw@latest

# 批准构建脚本（pnpm 需要）
pnpm approve-builds -g

# 运行配置向导
openclaw onboard --install-daemon
```

<details>
<summary>⚠️ sharp 构建错误解决方案</summary>

如果在 macOS 上遇到 `sharp` 构建错误，通常是因为系统安装了 libvips：

**方案 1**: 使用环境变量（推荐）
```bash
SHARP_IGNORE_GLOBAL_LIBVIPS=1 npm install -g openclaw@latest
```

**方案 2**: 安装构建工具
```bash
# macOS
xcode-select --install
npm install -g node-gyp

# 然后重新安装
npm install -g openclaw@latest
```

</details>

---

### 方法二：从源码安装

适合开发者或需要自定义构建的用户。

```bash
# 1. 克隆仓库
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# 2. 安装依赖
pnpm install

# 3. 构建 UI 和核心
pnpm ui:build
pnpm build

# 4. 全局链接 CLI
pnpm link --global

# 5. 运行配置向导
openclaw onboard --install-daemon
```

<details>
<summary>📁 源码目录结构</summary>

```
openclaw/
├── src/              # 源代码
├── ui/               # Web UI 源代码
├── docs/             # 文档
├── package.json      # 项目配置
└── pnpm-workspace.yaml
```

</details>

---

### 方法三：Docker 安装

适合容器化部署或隔离环境。

```bash
# 1. 拉取镜像
docker pull openclaw/openclaw:latest

# 2. 创建配置目录
mkdir -p ~/.openclaw
cd ~/.openclaw

# 3. 运行容器
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -v ~/.openclaw:/root/.openclaw \
  -e ANTHROPIC_API_KEY=your_api_key \
  openclaw/openclaw:latest

# 4. 查看日志
docker logs -f openclaw
```

<details>
<summary>🐳 Docker Compose 配置</summary>

```yaml
version: '3.8'
services:
  openclaw:
    image: openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "18789:18789"
    volumes:
      - ~/.openclaw:/root/.openclaw
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - OPENCLAW_PORT=18789
    restart: unless-stopped
```

保存为 `docker-compose.yml`，然后运行：
```bash
docker-compose up -d
```

</details>

---

### 方法四：本地前缀安装（无需 root）

适合没有 root 权限的环境。

```bash
# 使用 install-cli.sh 安装到本地目录
curl -fsSL https://openclaw.ai/install-cli.sh | bash

# 自定义安装路径
curl -fsSL https://openclaw.ai/install-cli.sh | bash -s -- --prefix /opt/openclaw

# 添加 PATH 到 shell 配置
export PATH="$HOME/.openclaw/bin:$PATH"
echo 'export PATH="$HOME/.openclaw/bin:$PATH"' >> ~/.bashrc
```

---

## 首次配置

安装完成后，运行配置向导：

```bash
openclaw onboard --install-daemon
```

### 配置向导步骤

#### 1️⃣ 选择配置模式

```
? 选择配置模式
❯ QuickStart (默认配置，快速开始)
  Advanced (完整控制，自定义所有选项)
```

**QuickStart** 使用默认配置，适合大多数用户。  
**Advanced** 允许自定义每个步骤。

#### 2️⃣ 配置 AI 模型和认证

```
? 选择 AI 提供商
❯ Anthropic (推荐)
  OpenAI
  Custom Provider (OpenAI 兼容)
  Custom Provider (Anthropic 兼容)
  跳过（稍后配置）
```

**Anthropic API Key 获取：**
1. 访问 https://console.anthropic.com
2. 注册/登录账号
3. 进入 API Keys 页面
4. 创建新密钥

<details>
<summary>🔑 支持的 AI 提供商</summary>

| 提供商 | 环境变数 | 文档 |
|--------|---------|------|
| Anthropic | `ANTHROPIC_API_KEY` | [Anthropic Docs](https://docs.anthropic.com) |
| OpenAI | `OPENAI_API_KEY` | [OpenAI Docs](https://platform.openai.com) |
| Azure OpenAI | `AZURE_OPENAI_API_KEY` | [Azure Docs](https://learn.microsoft.com) |
| 本地模型 | - | [本地模型指南](/nodes) |

</details>

#### 3️⃣ 选择默认模型

```
? 选择默认模型
❯ claude-sonnet-4-20250514 (平衡性能和成本)
  claude-opus-4-20250514 (最强性能)
  claude-haiku-4-20250514 (快速、低成本)
```

#### 4️⃣ 配置工作空间

```
? 工作空间路径 (~/.openclaw/workspace)
```

工作空间存储：
- 配置文件
- 记忆文件（MEMORY.md）
- 技能（Skills）
- 项目文件

#### 5️⃣ 配置网关

```
? 网关端口 (18789)
? 绑定地址 (127.0.0.1)
? 认证模式
❯ Token (推荐)
  None (仅本地测试)
```

<details>
<summary>🔐 网关认证模式</summary>

| 模式 | 说明 | 适用场景 |
|------|------|---------|
| Token | 使用访问令牌认证 | 生产环境 |
| None | 无需认证 | 本地测试、开发 |
| Basic | HTTP Basic 认证 | 内部网络 |

</details>

#### 6️⃣ 配置聊天渠道（可选）

```
? 要配置的渠道
❯◯ WhatsApp
 ◯ Telegram
 ◯ Discord
 ◯ Google Chat
 ◯ iMessage (macOS)
```

可以跳过此步骤，稍后单独配置。

#### 7️⃣ 安装守护进程

```
? 安装网关服务？
❯ Yes (推荐，开机自启)
  No (手动启动)
```

**macOS**: 创建 LaunchAgent  
**Linux/WSL2**: 创建 systemd user unit

#### 8️⃣ 安装推荐技能

```
? 安装推荐技能？
❯ Yes
  No
```

推荐技能包括：
- GitHub 操作
- 天气查询
- 文件处理
- 网络搜索

---

## 启动网关

### 方式一：作为服务运行（推荐）

如果安装时选择了安装守护进程，网关会自动启动：

```bash
# 检查服务状态
openclaw gateway status

# 启动服务
openclaw gateway start

# 停止服务
openclaw gateway stop

# 重启服务
openclaw gateway restart

# 查看服务日志
openclaw logs
```

### 方式二：前台运行（调试用）

```bash
# 默认端口 18789
openclaw gateway --port 18789

# 自定义端口
openclaw gateway --port 9000

# 详细日志
openclaw gateway --log-level debug
```

### 方式三：使用 Docker

```bash
# 启动容器
docker start openclaw

# 查看日志
docker logs -f openclaw

# 进入容器
docker exec -it openclaw bash
```

---

## 连接聊天渠道

### Telegram

```bash
# 1. 获取 Bot Token
# 在 Telegram 中联系 @BotFather 创建机器人

# 2. 登录 Telegram
openclaw channels login telegram

# 3. 输入 Bot Token
# 按提示完成配置

# 4. 测试
openclaw message send --target @username --message "Hello from OpenClaw"
```

### WhatsApp

```bash
# 1. 登录 WhatsApp
openclaw channels login whatsapp

# 2. 扫描二维码
# 使用手机 WhatsApp 扫描二维码

# 3. 等待同步完成
```

### Discord

```bash
# 1. 创建 Discord 应用
# 访问 https://discord.com/developers/applications

# 2. 获取 Bot Token

# 3. 配置 Discord
openclaw channels login discord

# 4. 输入 Token 和邀请链接
```

### iMessage (macOS)

```bash
# 1. 确保 macOS 10.15+

# 2. 配置 iMessage
openclaw channels login imessage

# 3. 授予辅助功能权限
```

<details>
<summary>📱 所有支持的渠道</summary>

| 渠道 | 状态 | 文档 |
|------|------|------|
| Telegram | ✅ 稳定 | [Telegram 配置](/channels/telegram) |
| WhatsApp | ✅ 稳定 | [WhatsApp 配置](/channels/whatsapp) |
| Discord | ✅ 稳定 | [Discord 配置](/channels/discord) |
| Google Chat | ✅ 稳定 | [Google Chat 配置](/channels/googlechat) |
| iMessage | ✅ macOS | [iMessage 配置](/channels/imessage) |
| Signal | 🧪 测试 | [Signal 配置](/channels/signal) |
| Mattermost | 🔌 插件 | [Mattermost 插件](/plugins/mattermost) |
| Slack | 🔌 插件 | [Slack 插件](/plugins/slack) |

</details>

---

## 验证安装

### 1. 检查网关状态

```bash
openclaw gateway status
```

**预期输出：**
```
Gateway: running
Port: 18789
Bind: 127.0.0.1
Auth: token
Uptime: 2h 15m
```

### 2. 打开控制面板

```bash
openclaw dashboard
```

这会在浏览器中打开 Control UI（默认 http://127.0.0.1:18789）

### 3. 运行健康检查

```bash
openclaw doctor
```

**检查项目：**
- ✅ Node.js 版本
- ✅ 配置文件
- ✅ 网关连接
- ✅ 渠道状态
- ✅ API 密钥

### 4. 发送测试消息

```bash
# 发送到 Telegram
openclaw message send --target @username --message "测试消息"

# 发送到 WhatsApp
openclaw message send --target +1234567890 --message "测试消息"
```

### 5. 检查会话

```bash
# 列出所有会话
openclaw sessions list

# 查看会话历史
openclaw sessions history <session-key>
```

---

## 常见问题

### ❌ `openclaw` 命令找不到

**原因**: PATH 环境变量未配置

**解决方案：**

```bash
# 1. 检查 npm 全局前缀
npm prefix -g

# 2. 添加到 shell 配置
echo 'export PATH="$(npm prefix -g)/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 3. 重新打开终端
```

---

### ❌ Node.js 版本过低

**原因**: 系统 Node.js 版本低于 22

**解决方案：**

```bash
# 方法 1: 使用 nvm (推荐)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 22
nvm use 22

# 方法 2: 使用官方安装包
# macOS
brew install node@22

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# 重新运行 OpenClaw 安装
openclaw onboard
```

---

### ❌ sharp 构建失败

**原因**: libvips 冲突或缺少构建工具

**解决方案：**

```bash
# 方法 1: 忽略全局 libvips
SHARP_IGNORE_GLOBAL_LIBVIPS=1 npm install -g openclaw@latest

# 方法 2: 安装构建工具
# macOS
xcode-select --install

# Ubuntu/Debian
sudo apt-get install -y build-essential python3

# 重新安装
npm install -g openclaw@latest
```

---

### ❌ 网关无法启动

**原因**: 端口占用或配置错误

**解决方案：**

```bash
# 1. 检查端口占用
lsof -i :18789

# 2. 更换端口
openclaw gateway --port 9000

# 3. 检查配置文件
cat ~/.openclaw/openclaw.json

# 4. 查看详细日志
openclaw gateway --log-level debug
```

---

### ❌ 渠道连接失败

**原因**: Token 错误或网络问题

**解决方案：**

```bash
# 1. 验证 Token
openclaw channels status

# 2. 重新登录
openclaw channels logout <channel>
openclaw channels login <channel>

# 3. 检查网络
ping api.telegram.org  # Telegram 示例

# 4. 查看渠道日志
openclaw logs --grep <channel>
```

---

### ❌ API 密钥错误

**原因**: 密钥无效或权限不足

**解决方案：**

```bash
# 1. 验证密钥
curl -H "Authorization: Bearer $ANTHROPIC_API_KEY" \
  https://api.anthropic.com/v1/models

# 2. 重新配置
openclaw configure --section auth

# 3. 检查环境变量
echo $ANTHROPIC_API_KEY
```

---

### ❌ 内存不足

**原因**: 系统内存不足 2GB

**解决方案：**

```bash
# 1. 检查内存
free -h  # Linux
top      # macOS

# 2. 关闭其他应用

# 3. 增加 swap (Linux)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 4. 考虑升级硬件
```

---

## 高级配置

### 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `OPENCLAW_HOME` | 自定义 home 目录 | `~/.openclaw` |
| `OPENCLAW_STATE_DIR` | 状态目录 | `~/.openclaw-state` |
| `OPENCLAW_CONFIG_PATH` | 配置文件路径 | `~/.openclaw/openclaw.json` |
| `OPENCLAW_PORT` | 网关端口 | `18789` |
| `ANTHROPIC_API_KEY` | Anthropic API 密钥 | - |
| `OPENAI_API_KEY` | OpenAI API 密钥 | - |

### 配置文件示例

`~/.openclaw/openclaw.json`:

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "YOUR_BOT_TOKEN"
    },
    "whatsapp": {
      "enabled": true,
      "allowFrom": ["+1234567890"]
    }
  },
  "agents": {
    "default": {
      "model": "claude-sonnet-4-20250514",
      "provider": "anthropic"
    }
  },
  "gateway": {
    "port": 18789,
    "bind": "127.0.0.1",
    "auth": {
      "mode": "token",
      "token": "auto-generated"
    }
  },
  "messages": {
    "groupChat": {
      "requireMention": true
    }
  }
}
```

### 多 Agent 配置

```bash
# 添加新 Agent
openclaw agents add researcher --workspace ~/research-agent

# 配置不同模型
openclaw agents config researcher --model claude-opus-4-20250514

# 列出所有 Agent
openclaw agents list

# 切换默认 Agent
openclaw agents use researcher
```

### 远程访问

```bash
# 1. 配置 Tailscale（推荐）
openclaw gateway tailscale up

# 2. 或使用 SSH 隧道
ssh -L 18789:localhost:18789 user@remote-host

# 3. 或在防火墙开放端口（不推荐）
openclaw gateway --bind 0.0.0.0
```

### 性能优化

```json
{
  "gateway": {
    "maxConcurrentSessions": 10,
    "sessionTimeout": 3600,
    "messageQueueSize": 1000
  },
  "agents": {
    "maxTokens": 4096,
    "temperature": 0.7
  }
}
```

---

## 下一步

安装完成后，你可以：

1. 📚 **阅读文档**: [OpenClaw 文档中心](https://docs.openclaw.ai)
2. 💬 **加入社区**: [Discord 社区](https://discord.com/invite/clawd)
3. 🛠️ **学习技能**: [技能开发指南](/skills)
4. 🔌 **安装插件**: [插件市场](/plugins)
5. 📱 **配置节点**: [移动节点配置](/nodes)

---

## 资源链接

- **官方文档**: https://docs.openclaw.ai
- **GitHub 仓库**: https://github.com/openclaw/openclaw
- **Discord 社区**: https://discord.com/invite/clawd
- **问题反馈**: https://github.com/openclaw/openclaw/issues
- **更新日志**: https://github.com/openclaw/openclaw/releases

---

## 许可证

OpenClaw 使用 MIT 许可证。详见 [LICENSE](https://github.com/openclaw/openclaw/blob/main/LICENSE)。

---

*文档由 OpenClaw 社区维护，欢迎提交 PR 改进！* 🦞
