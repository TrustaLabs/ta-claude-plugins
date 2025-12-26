#!/bin/bash
set -euo pipefail

# 读取 hook 输入
input=$(cat)

# 提取文件路径
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# 如果没有文件路径，直接允许
if [ -z "$file_path" ]; then
  echo '{"hookSpecificOutput": {"permissionDecision": "allow"}, "systemMessage": ""}'
  exit 0
fi

# 检查是否启用了自动注入（通过配置文件）
config_file="$CLAUDE_PROJECT_DIR/.claude/team-context-config.json"
if [ -f "$config_file" ]; then
  enabled=$(jq -r '.autoInject // true' "$config_file")
  if [ "$enabled" != "true" ]; then
    echo '{"hookSpecificOutput": {"permissionDecision": "allow"}, "systemMessage": ""}'
    exit 0
  fi
fi

# 获取文件扩展名
ext="${file_path##*.}"

# 根据文件扩展名决定加载哪些知识类型
knowledge_types=""

case "$ext" in
  ts|tsx|js|jsx)
    knowledge_types="coding-standards,architecture"
    ;;
  py)
    knowledge_types="coding-standards"
    ;;
  *)
    # 其他文件类型不加载
    echo '{"hookSpecificOutput": {"permissionDecision": "allow"}, "systemMessage": ""}'
    exit 0
    ;;
esac

# 检查文件路径中的关键词
if [[ "$file_path" == *"test"* ]] || [[ "$file_path" == *"spec"* ]]; then
  knowledge_types="coding-standards"
elif [[ "$file_path" == *"api"* ]] || [[ "$file_path" == *"service"* ]]; then
  knowledge_types="coding-standards,architecture,business"
fi

# 读取团队知识文件
team_context_file="$CLAUDE_PROJECT_DIR/docs/team-context.md"

if [ ! -f "$team_context_file" ]; then
  # 文件不存在，直接允许
  echo '{"hookSpecificOutput": {"permissionDecision": "allow"}, "systemMessage": ""}'
  exit 0
fi

# 提取相关章节（简化版：只提取章节标题和前几行）
context_message="已自动加载团队规范（$knowledge_types）：\n\n"

# 根据知识类型提取相关章节
if [[ "$knowledge_types" == *"coding-standards"* ]]; then
  # 提取编码规范章节（第1章）
  coding_section=$(sed -n '/^## 1\. 编码规范/,/^## 2\./p' "$team_context_file" | head -n 50)
  context_message+="$coding_section\n\n"
fi

if [[ "$knowledge_types" == *"architecture"* ]]; then
  # 提取架构设计章节（第2章）
  arch_section=$(sed -n '/^## 2\. 架构设计/,/^## 3\./p' "$team_context_file" | head -n 50)
  context_message+="$arch_section\n\n"
fi

if [[ "$knowledge_types" == *"business"* ]]; then
  # 提取业务知识章节（第3章）
  business_section=$(sed -n '/^## 3\. 业务知识/,/^## 4\./p' "$team_context_file" | head -n 50)
  context_message+="$business_section\n\n"
fi

# 构建输出 JSON
output=$(jq -n \
  --arg msg "$context_message" \
  '{
    "hookSpecificOutput": {
      "permissionDecision": "allow"
    },
    "systemMessage": $msg
  }')

echo "$output"
exit 0
