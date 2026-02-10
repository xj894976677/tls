#!/bin/bash
# ==========================================================================
# tls 构建脚本
# 清除旧 lib/ → tsc 重新编译
#
# 产物: lib/ (TypeScript 编译输出)
# ==========================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "[tls] 步骤 1: 清除旧构建产物和缓存"
echo "=========================================="
rm -rf lib 2>/dev/null || true
rm -rf node_modules/.cache 2>/dev/null || true
# tsc 增量编译缓存
rm -f tsconfig.build.tsbuildinfo 2>/dev/null || true
echo "  已清除 lib/ 和缓存"

echo ""
echo "=========================================="
echo "[tls] 步骤 2: 检查依赖"
echo "=========================================="
if [ ! -d "node_modules" ]; then
    echo "  npm install..."
    npm install
else
    echo "  node_modules 已存在"
fi

echo ""
echo "=========================================="
echo "[tls] 步骤 3: TypeScript 编译"
echo "=========================================="
npm run build

echo ""
echo "=========================================="
echo "[tls] 步骤 4: 验证产物"
echo "=========================================="
if [ ! -f "lib/index.js" ]; then
    echo "错误: lib/index.js 不存在"
    exit 1
fi
if [ ! -f "lib/index.d.ts" ]; then
    echo "错误: lib/index.d.ts 不存在"
    exit 1
fi
echo "  lib/ 产物完整 ✓"

echo ""
echo "[tls] 构建完成"
