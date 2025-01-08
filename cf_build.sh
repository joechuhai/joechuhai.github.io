#!/bin/bash

echo "🚀 开始构建..."

# 显示系统 Ruby 版本
echo "📦 系统 Ruby 版本:"
ruby --version

# 设置构建环境
echo "⚙️ 配置构建环境..."
bundle config set --local path 'vendor/bundle'
bundle config set --local deployment 'true'
bundle config set --local without 'development test'

# 安装依赖
echo "📦 安装依赖..."
bundle install --jobs=$(nproc) --retry=3

# 清理之前的构建
echo "🧹 清理之前的构建..."
rm -rf generated

# 并行构建站点
echo "🏗️ 并行构建站点..."

# 构建英文站点
echo "🇺🇸 构建英文站点..."
JEKYLL_ENV=production bundle exec jekyll build \
  --config _config_en.yml \
  --source blog/en \
  --destination generated/en \
  --trace

# 构建中文站点
echo "🇨🇳 构建中文站点..."
JEKYLL_ENV=production bundle exec jekyll build \
  --config _config_zh.yml \
  --source blog/zh \
  --destination generated/zh \
  --trace

# 复制语言选择页面
echo "📋 复制语言选择页面..."
cp blog/index.html generated/

# 复制资源文件
echo "📋 复制资源文件..."

# 复制英文版资源
echo "复制英文资源..."
mkdir -p generated/en/assets
cp -r blog/en/assets/* generated/en/assets/

# 复制中文版资源
echo "复制中文资源..."
mkdir -p generated/zh/assets
cp -r blog/zh/assets/* generated/zh/assets/

# 复制广告文件（可选）
echo "复制 ads.txt..."
if [ -f "ads.txt" ]; then
    cp ads.txt generated/
else
    echo "⚠️ ads.txt 不存在，跳过复制"
fi

echo "✅ 所有文件处理完成"
