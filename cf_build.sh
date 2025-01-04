#!/bin/bash
set -e

# 安装依赖
bundle install

# 创建必要的目录
mkdir -p generated/en
mkdir -p generated/zh

# 构建英文站点
JEKYLL_ENV=production bundle exec jekyll build -d ./generated/en --source ./blog/en --config _config_en.yml

# 构建中文站点
JEKYLL_ENV=production bundle exec jekyll build -d ./generated/zh --source ./blog/zh --config _config_zh.yml

# 复制主页
cp blog/index.html ./generated/index.html