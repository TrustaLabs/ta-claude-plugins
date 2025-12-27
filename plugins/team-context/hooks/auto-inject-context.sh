#!/bin/bash
set -euo pipefail

# ============================================================================
# 团队知识上下文自动注入 Hook
# 版本: 2.0.0
# 功能: 基于文件类型、路径和工具类型智能推断标签，加载匹配的团队规范
# ============================================================================

# ----------------------------------------------------------------------------
# 标签推断模块
# 功能: 根据文件路径和工具类型推断需要加载的标签
# 参数: $1 = 文件路径, $2 = 工具名称
# 输出: 逗号分隔的标签列表
# ----------------------------------------------------------------------------
infer_tags() {
  local file_path="$1"
  local tool_name="$2"
  local tags=()

  # 基于工具类型推断
  if [[ "$tool_name" == "EnterPlanMode" ]]; then
    echo "architecture,workflow,business"
    return
  fi

  # 基于文件扩展名推断
  if [ -n "$file_path" ]; then
    local ext="${file_path##*.}"
    case "$ext" in
      tsx|jsx)
        tags+=(coding-standards architecture.frontend architecture.react)
        ;;
      vue)
        tags+=(coding-standards architecture.frontend architecture.vue)
        ;;
      ts|js)
        tags+=(coding-standards)
        # 检查是否在 api/service 目录
        if [[ "$file_path" =~ (api|service) ]]; then
          tags+=(architecture.backend architecture.api business)
        fi
        ;;
      py)
        tags+=(coding-standards architecture.backend)
        ;;
      css|scss|sass|less)
        tags+=(coding-standards.styling architecture.frontend)
        ;;
      json|yaml|yml)
        if [[ "$file_path" =~ config ]]; then
          tags+=(architecture.config)
        fi
        ;;
      md)
        tags+=(workflow.documentation)
        ;;
    esac

    # 基于路径关键词推断
    if [[ "$file_path" =~ /auth/|/login/ ]]; then
      tags+=(business.auth)
    fi
    if [[ "$file_path" =~ /order/|/payment/ ]]; then
      tags+=(business.order)
    fi
    if [[ "$file_path" =~ /component/|/ui/ ]]; then
      tags+=(architecture.frontend)
    fi
    if [[ "$file_path" =~ /test/|/spec/|\.test\.|\.spec\. ]]; then
      tags+=(coding-standards.testing workflow.testing)
    fi
    if [[ "$file_path" =~ /utils/|/helpers/ ]]; then
      tags+=(coding-standards.utils)
    fi
  fi

  # 去重并返回
  if [ ${#tags[@]} -eq 0 ]; then
    echo ""
  else
    printf '%s\n' "${tags[@]}" | sort -u | tr '\n' ',' | sed 's/,$//'
  fi
}

# ----------------------------------------------------------------------------
# 标签匹配模块
# 功能: 检查章节标签是否匹配需求标签（支持精确匹配和前缀匹配）
# 参数: $1 = 需求标签（逗号分隔）, $2 = 章节标签（逗号分隔）
# 返回: 0 = 匹配, 1 = 不匹配
# ----------------------------------------------------------------------------
match_tags() {
  local required_tags="$1"
  local section_tags="$2"

  # 将逗号分隔的字符串转换为数组
  IFS=',' read -ra req_array <<< "$required_tags"
  IFS=',' read -ra sec_array <<< "$section_tags"

  for req_tag in "${req_array[@]}"; do
    req_tag=$(echo "$req_tag" | xargs) # 去除空格
    for sec_tag in "${sec_array[@]}"; do
      sec_tag=$(echo "$sec_tag" | xargs) # 去除空格

      # 精确匹配
      if [[ "$req_tag" == "$sec_tag" ]]; then
        return 0
      fi

      # 前缀匹配（例如 architecture 匹配 architecture.frontend）
      if [[ "$sec_tag" == "$req_tag".* ]] || [[ "$req_tag" == "$sec_tag".* ]]; then
        return 0
      fi
    done
  done

  return 1
}

# ----------------------------------------------------------------------------
# 主流程
# ----------------------------------------------------------------------------

# 读取 hook 输入
input=$(cat)

# 提取工具信息
tool_name=$(echo "$input" | jq -r '.tool_name // ""')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# 检查是否启用自动注入
config_file="$CLAUDE_PROJECT_DIR/.claude/team-context-config.json"
if [ -f "$config_file" ]; then
  enabled=$(jq -r '.autoInject // true' "$config_file")
  if [ "$enabled" != "true" ]; then
    echo '{"hookSpecificOutput": {"permissionDecision": "allow"}, "systemMessage": ""}'
    exit 0
  fi
fi

# 推断标签
required_tags=$(infer_tags "$file_path" "$tool_name")

# 如果没有推断出标签，直接允许
if [ -z "$required_tags" ]; then
  echo '{"hookSpecificOutput": {"permissionDecision": "allow"}, "systemMessage": ""}'
  exit 0
fi

# 读取团队知识文件
team_context_file="$CLAUDE_PROJECT_DIR/docs/team-context.md"
if [ ! -f "$team_context_file" ]; then
  echo '{"hookSpecificOutput": {"permissionDecision": "allow"}, "systemMessage": ""}'
  exit 0
fi

# 解析文档，收集匹配的章节
matched_sections=""
current_section=""
current_tags=""
in_frontmatter=false
in_section=false
line_count=0
max_lines_per_section=100

while IFS= read -r line; do
  # 检测 YAML frontmatter 开始/结束
  if [[ "$line" == "---" ]]; then
    if [ "$in_frontmatter" = false ]; then
      # 开始新的 frontmatter
      in_frontmatter=true

      # 如果之前有章节，检查是否匹配
      if [ "$in_section" = true ] && [ -n "$current_tags" ]; then
        if match_tags "$required_tags" "$current_tags"; then
          matched_sections+="$current_section"$'\n\n'
        fi
      fi

      # 重置状态
      current_section=""
      current_tags=""
      in_section=true
      line_count=0
    else
      # 结束 frontmatter
      in_frontmatter=false
    fi
    continue
  fi

  # 在 frontmatter 内，提取标签
  if [ "$in_frontmatter" = true ]; then
    if [[ "$line" =~ ^tags:\ \[(.*)\] ]]; then
      current_tags="${BASH_REMATCH[1]}"
    fi
    continue
  fi

  # 在章节内容中
  if [ "$in_section" = true ] && [ "$in_frontmatter" = false ]; then
    # 限制每个章节的行数
    if [ $line_count -lt $max_lines_per_section ]; then
      current_section+="$line"$'\n'
      ((line_count++))
    fi
  fi
done < "$team_context_file"

# 处理最后一个章节
if [ "$in_section" = true ] && [ -n "$current_tags" ]; then
  if match_tags "$required_tags" "$current_tags"; then
    matched_sections+="$current_section"
  fi
fi

# 构建输出
if [ -n "$matched_sections" ]; then
  context_message="已自动加载团队规范（标签: $required_tags）：

$matched_sections"
else
  context_message=""
fi

# 限制输出大小（< 10KB）
max_size=10240
if [ ${#context_message} -gt $max_size ]; then
  context_message="${context_message:0:$max_size}...

[输出已截断，超过 10KB 限制]"
fi

# 构建 JSON 输出
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
