#!/bin/bash

#####################################
# OpenClaw 一键安装脚本
# 支持: Ubuntu 18.04+, Debian 10+
#####################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 打印带颜色的函数
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_step() {
    echo -e "\n${YELLOW}▶ $1${NC}"
}

# 检测系统
print_step "检测系统信息..."
if [ -f /etc/os-release ]; then
    source /etc/os-release
    DISTRO=${ID}
    VERSION=${VERSION_ID}
    print_success "检测到系统: ${DISTRO} ${VERSION}"
else
    print_error "不支持的系统，需要 Ubuntu 或 Debian"
    exit 1
fi

# 检查 root 权限
if [ "$EUID" -ne 0 ]; then
    print_error "需要 root 权限运行此脚本"
    print_info "请使用: sudo bash $0"
    exit 1
fi
print_success "Root 权限检查通过"

# 更新软件包列表
print_step "更新软件包列表..."
apt-get update -qq
print_success "软件包列表更新完成"

# 安装基础依赖
print_step "安装基础依赖..."
apt-get install -y curl wget gnupg ca-certificates -qq
print_success "基础依赖安装完成"

# 安装 Node.js 20.x
print_step "安装 Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
print_success "Node.js 20.x 安装完成"
node --version

# 验证安装
print_step "验证 Node.js 安装..."
npm --version

# 安装 OpenClaw CLI
print_step "安装 OpenClaw CLI..."
npm install -g --silent
print_success "OpenClaw CLI 安装完成"

# 验证 OpenClaw 安装
print_step "验证 OpenClaw CLI 安装..."
if command -v openclaw &> /dev/null; then
    openclaw version
    print_success "OpenClaw CLI 验证成功"
else
    print_error "Openclaw CLI 安装失败"
    exit 1
fi

# 配置目录
print_step "配置 OpenClaw 工作目录..."
mkdir -p ~/.openclaw/skills ~/.openclaw/workspace ~/.openclaw/memory
print_success "OpenClaw 目录配置完成"

# 可选：安装推荐技能
print_info ""
read -p "是否安装推荐技能？(y/N): " install_skills
echo ""

if [ "$install_skills" = "y" ] || [ "$install_skills" = "Y" ]; then
    print_step "安装推荐技能..."
    
    # MOLTRON - 自我进化技能
    print_info "正在安装 MOLTRON（自我进化）..."
    curl -fsSL https://github.com/adridder/moltron/raw/main/install.sh | bash
    
    # 企业微信桥接技能
    print_info "正在安装企业微信桥接技能..."
    git clone https://github.com/lewiszeng666/wecom-openclaw-bridge-skill.git ~/.openclaw/skills/wecom-openclaw-bridge-skill 2>/dev/null || print_info "企业微信桥接技能已存在或克隆失败"
    
    print_success "推荐技能安装完成"
fi

# 验证安装
print_step "验证 OpenClaw 安装..."
openclaw version

# 生成配置检查
print_step "生成配置检查..."
cat << 'EOF'

${GREEN}
========================================
 OpenClaw 安装完成！
========================================${NC}

${BLUE}版本信息：${NC}
$(openclaw version)

${BLUE}常用命令：${NC}
  openclaw status      # 查看状态
  openclaw models       # 列出可用模型
  openclaw help         # 查看帮助
  openclaw skills       # 管理技能

${BLUE}配置文件位置：${NC}
  ~/.openclaw/models.json    # 模型配置
  ~/.openclaw/settings.json  # 全局设置

${BLUE}工作目录：${NC}
  ~/.openclaw/skills/      # 技能目录
  ~/.openclaw/workspace/    # 工作空间
  ~/.openclaw/memory/       # 内存文件

${BLUE}下一步：${NC}
  1. 配置模型: openclaw models
  2. 初始化: openclaw onboard
  3. 开始使用: 在聊天中调用 @工具名

========================================
EOF

print_success "OpenClaw 安装成功！"