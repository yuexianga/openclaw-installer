# OpenClaw 一键安装脚本 🚀

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/yuexianga/openclaw-installer/blob/main/LICENSE)
![Platform](https://img.shields.io/badge/platform-ubuntu-orange.svg)
![Platform](https://img.shields.io/badge/platform-debian-red.svg)

一键安装 OpenClaw CLI 的 Bash 脚本，支持 Ubuntu 和 Debian 系统。

## ✨ 特性

- ✅ **自动检测系统**：识别 Ubuntu/Debian 版本
- ✅ **自动安装依赖**：Node.js 20.x、基础工具
- ✅ **自动安装 OpenClaw CLI**：最新版本
- ✅ **可选安装技能**：MOLTRON（自我进化）、企业微信桥接
- ✅ **自动配置目录**：skills、workspace、memory
- ✅ **安装验证**：检查安装状态并提供下一步指引

## 📦 支持系统

- Ubuntu 18.04 及以上
- Debian 10 及以上
- 其他基于 Debian 的发行版

## 🚀 快速安装

### 方法 1：一键下载安装

```bash
# 使用 curl 下载
bash <(curl -fsSL https://raw.githubusercontent.com/yuexianga/openclaw-installer/main/openclaw-installer.sh)
```

### 方法 2：克隆仓库后安装

```bash
# 克隆仓库
git clone https://github.com/yuexianga/openclaw-installer.git
cd openclaw-installer

# 运行安装脚本
bash openclaw-installer.sh
```

### 方法 3：使用 wget 下载安装

```bash
wget https://raw.githubusercontent.com/yuexianga/openclaw-installer/main/openclaw-installer.sh -O openclaw-installer.sh
bash openclaw-openclaw-installer.sh
```

## 🔧 安装过程

脚本会自动执行以下操作：

1. ✅ 检测系统和 root 权限
2. ✅ 更新软件包列表
3. ✅ 安装基础依赖（curl、wget、gnupg、ca-certificates）
4. ✅ 安装 Node.js 20.x
5. ✅ 安装 OpenClaw CLI
6. ✅ 配置工作目录
7. ✅ 可选：安装推荐技能（MOLTRON、企业微信桥接）

## 📋 可选安装的技能

安装时会提示是否安装以下技能：

- **MOLTRON** - AI 代理自我进化框架
- **企业微信桥接** - wecom-openclaw-bridge-skill

## 🔍 安装后验证

安装完成后，运行以下命令验证：

```bash
# 查看版本
openclaw version

# 列出可用模型
openclaw models

# 查看状态
openclaw status

# 查看技能列表
openclaw skills
```

## 📖 使用 OpenClaw

初始化 OpenClaw：

```bash
openclaw onboard
```

在聊天中调用技能：

```
@moltron help
```

## 🛠️ 故障排除

### 问题：权限错误

```
error: 需要 root 权限运行此脚本
```

**解决**：
```bash
sudo bash openclaw-installer.sh
```

### 问题：找不到命令

```
bash: openclaw: command not found
```

**解决**：
```bash
export PATH=$PATH:$HOME/.local/bin:$PATH
source ~/.bashrc
```

### 问题：Node.js 版本问题

**解决**：
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
npm install -g openclaw
```

## 📝 环境变量配置（可选）

如果需要使用特定模型或配置，编辑 `~/.openclaw/models.json`：

```json
{
  "default": "bailian/qwen3.5-plus",
  "preferred": ["bailian/qwen3.5-plus", "bailian/glm-5"],
  "env": {
    "API_KEY": "your-api-key-here"
  }
}
```

## 🤝 贡献

欢迎提交 Issue 或 Pull Request！

## 📄 License

MIT License

## 🔗 相关链接

- [OpenClaw 官网](https://openclaw.ai)
- [OpenClaw 文档](https://docs.openclaw.ai/)
- [GitHub 仓库](https://github.com/yuexianga/openclaw-installer)

---

**作者**: yuexianga