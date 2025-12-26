# 插件开发指南

本文档提供 Claude Code 插件开发的流程、规范和最佳实践。

## 目录

- [插件基础](#插件基础)
- [插件结构](#插件结构)
- [开发流程](#开发流程)
- [代码规范](#代码规范)
- [调试技巧](#调试技巧)
- [常见问题](#常见问题)

## 插件基础

### 什么是 Claude Code 插件？

Claude Code 插件是扩展 Claude Code 功能的模块化组件，可以添加自定义命令、技能和钩子。

### 插件类型

1. **单个插件**：独立的功能模块
2. **Marketplace**：包含多个插件的集合

### 核心概念

- **Commands（命令）**：用户可调用的斜杠命令（如 `/ta-init`）
- **Skills（技能）**：AI 自动触发的能力
- **Hooks（钩子）**：在特定事件触发的自动化操作

## 插件结构

### 单个插件结构

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json           # 插件配置文件（必需）
├── commands/                 # 命令目录（可选）
│   ├── my-command.md
│   └── another-command.md
├── skills/                   # 技能目录（可选）
│   ├── skill.md
│   ├── examples/
│   └── references/
├── hooks/                    # 钩子目录（可选）
│   └── hooks.json
└── README.md                 # 插件说明（推荐）
```

### Marketplace 结构

```
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json      # Marketplace 配置（必需）
├── plugins/
│   ├── plugin-a/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   └── ...
│   └── plugin-b/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       └── ...
└── README.md
```

### plugin.json 配置

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "插件描述",
  "author": {
    "name": "作者名称"
  },
  "repository": "https://github.com/username/repo",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "commands": ["./commands"],
  "skills": ["./skills"],
  "hooks": ["./hooks/hooks.json"]
}
```

**必需字段：**
- `name`：插件唯一标识符（kebab-case）
- `version`：语义化版本号
- `description`：简短描述

**可选字段：**
- `author`：作者信息
- `repository`：仓库地址
- `license`：许可证类型
- `keywords`：关键词数组
- `commands`：命令目录或文件路径数组
- `skills`：技能目录或文件路径数组
- `hooks`：钩子配置文件路径数组

### marketplace.json 配置

```json
{
  "name": "my-marketplace",
  "version": "1.0.0",
  "description": "Marketplace 描述",
  "owner": {
    "name": "所有者名称"
  },
  "plugins": [
    {
      "name": "plugin-a",
      "source": "./plugins/plugin-a",
      "description": "插件 A 描述"
    },
    {
      "name": "plugin-b",
      "source": "./plugins/plugin-b",
      "description": "插件 B 描述"
    }
  ]
}
```

## 开发流程

### 1. 创建新插件

```bash
# 创建插件目录结构
mkdir -p my-plugin/.claude-plugin
mkdir -p my-plugin/commands
mkdir -p my-plugin/skills
mkdir -p my-plugin/hooks

# 创建 plugin.json
cat > my-plugin/.claude-plugin/plugin.json << 'EOF'
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "我的插件",
  "commands": ["./commands"],
  "skills": ["./skills"]
}
EOF
```

### 2. 开发命令

命令文件使用 Markdown 格式，包含以下部分：

```markdown
# 命令名称

命令描述

## 使用方法

\`\`\`bash
/my-command [参数]
\`\`\`

## 功能特性

- 特性 1
- 特性 2

## 执行指令

当此命令被调用时，执行以下步骤：

### 步骤 1：...

描述步骤 1

### 步骤 2：...

描述步骤 2
```

**命令文件命名规范：**
- 使用 kebab-case（如 `my-command.md`）
- 文件名应与命令名对应（`/my-command` → `my-command.md`）

### 3. 开发技能

技能文件定义 AI 自动触发的能力：

```markdown
# 技能名称

技能描述

## 触发条件

描述何时触发此技能

## 执行流程

描述技能执行的步骤

## 示例

提供使用示例
```

**技能组织：**
- 主技能文件：`skill.md` 或 `SKILL.md`
- 示例：`examples/` 目录
- 参考资料：`references/` 目录

### 4. 开发钩子

钩子配置使用 JSON 格式：

```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "condition": "toolName === 'Write'",
      "action": "inject-context",
      "context": "团队编码规范"
    }
  ]
}
```

**支持的事件：**
- `PreToolUse`：工具调用前
- `PostToolUse`：工具调用后
- `SessionStart`：会话开始
- `SessionEnd`：会话结束

### 5. 本地测试

```bash
# 安装本地插件
claude plugin install ./my-plugin

# 查看已安装插件
claude plugin list

# 测试命令
/my-command

# 卸载插件
claude plugin uninstall my-plugin
```

### 6. 提交代码

```bash
# 创建分支
git checkout -b feature/my-plugin

# 提交更改
git add .
git commit -m "feat(my-plugin): 添加新插件"

# 推送到远程
git push origin feature/my-plugin
```

## 代码规范

### 文档规范

1. **Markdown 格式**
   - 使用中文书写文档和注释
   - 标题层级清晰（`#` 到 `####`）
   - 代码块使用三个反引号，指定语言类型
   - 使用列表和表格提高可读性

2. **文件命名**
   - 使用 kebab-case（如 `my-command.md`）
   - 文件名应描述性强
   - 避免使用特殊字符

3. **内容组织**
   - 使用目录（TOC）
   - 逻辑分段
   - 提供示例
   - 包含相关链接

### 插件配置规范

1. **plugin.json**
   ```json
   {
     "name": "plugin-name",
     "version": "1.0.0",
     "description": "简短描述",
     "author": {
       "name": "作者名称"
     },
     "repository": "https://github.com/username/repo",
     "license": "MIT",
     "keywords": ["keyword1", "keyword2"]
   }
   ```

2. **版本号**
   - 使用语义化版本号（Semantic Versioning）
   - MAJOR.MINOR.PATCH
   - 更新版本号时同步更新所有配置文件

3. **关键词**
   - 使用准确的关键词
   - 便于搜索和发现
   - 3-5 个关键词

### 命令开发规范

1. **命令文件结构**
   ```markdown
   # 命令名称

   命令描述

   ## 使用方法

   ## 功能特性

   ## 执行指令
   ```

2. **命令命名**
   - 使用 kebab-case
   - 简短且描述性强
   - 避免与内置命令冲突

3. **参数设计**
   - 提供清晰的参数说明
   - 使用可选参数
   - 提供默认值

### 技能开发规范

1. **技能文件结构**
   ```markdown
   # 技能名称

   技能描述

   ## 触发条件

   ## 执行流程

   ## 示例
   ```

2. **渐进式披露**
   - 主文件包含核心内容
   - 详细内容放到 examples/ 和 references/
   - 控制文件大小（<500行）

3. **触发条件**
   - 明确定义触发条件
   - 避免过度触发
   - 提供示例

### 钩子开发规范

1. **钩子配置**
   ```json
   {
     "hooks": [
       {
         "event": "PreToolUse",
         "condition": "toolName === 'Write'",
         "action": "inject-context",
         "context": "上下文内容"
       }
     ]
   }
   ```

2. **事件选择**
   - 选择合适的事件类型
   - 避免过度干预
   - 考虑性能影响

3. **条件判断**
   - 使用精确的条件表达式
   - 避免误触发
   - 测试边界情况

### Git 提交规范

```
<type>(<scope>): <subject>
```

**Type（类型）：**
- `feat`：新功能
- `fix`：Bug 修复
- `docs`：文档更新
- `style`：代码格式
- `refactor`：重构
- `test`：测试相关
- `chore`：构建或辅助工具变动

**Scope（范围）：**
- `ta-spec`：项目规范管理插件
- `team-context`：团队知识上下文插件
- `marketplace`：Marketplace 配置
- `docs`：文档

**Subject（主题）：**
- 使用中文
- 简短描述（不超过 50 字）
- 使用祈使句

**示例：**
```
feat(ta-spec): 添加文档初始化命令
fix(team-context): 修复钩子触发条件
docs(readme): 更新安装说明
```

## 最佳实践

### 命令设计

1. **命名规范**
   - 使用简短、描述性的名称
   - 使用 kebab-case（如 `/my-command`）
   - 避免与内置命令冲突

2. **参数设计**
   - 提供清晰的参数说明
   - 使用可选参数提供灵活性
   - 提供默认值

3. **用户体验**
   - 提供清晰的使用说明
   - 包含示例
   - 提供错误提示

### 技能设计

1. **触发条件**
   - 明确定义触发条件
   - 避免过度触发
   - 提供用户控制选项

2. **渐进式披露**
   - 主文件包含核心内容
   - 详细内容放到 examples/ 和 references/
   - 使用 Reference 机制引导 AI

3. **性能优化**
   - 避免加载不必要的内容
   - 使用条件加载
   - 控制文档大小

### 钩子设计

1. **事件选择**
   - 选择合适的事件类型
   - 避免过度干预
   - 提供禁用选项

2. **条件判断**
   - 使用精确的条件表达式
   - 避免误触发
   - 考虑边界情况

3. **性能影响**
   - 最小化钩子执行时间
   - 避免阻塞操作
   - 使用异步操作

### 文档规范

1. **README.md**
   - 清晰的插件描述
   - 完整的安装说明
   - 详细的使用示例

2. **命令文档**
   - 使用 Markdown 格式
   - 包含使用方法和示例
   - 提供执行指令

3. **代码注释**
   - 使用中文注释
   - 解释复杂逻辑
   - 提供示例

### 版本管理

1. **语义化版本**
   - MAJOR：不兼容的 API 变更
   - MINOR：向后兼容的功能新增
   - PATCH：向后兼容的问题修复

2. **变更日志**
   - 记录每个版本的变更
   - 包含破坏性变更说明

## 调试技巧

### 1. 查看插件状态

```bash
# 列出已安装插件
claude plugin list

# 查看插件详情
claude plugin info my-plugin
```

### 2. 测试命令

```bash
# 直接调用命令
/my-command

# 查看命令帮助
/help my-command
```

### 3. 调试技能

- 在技能文件中添加调试输出
- 使用注释说明执行步骤
- 测试不同触发条件

### 4. 调试钩子

- 检查钩子配置是否正确
- 验证条件表达式
- 测试不同事件触发

## 常见问题

### Q1: 插件无法加载

**可能原因：**
- `plugin.json` 格式错误
- 路径配置不正确
- 缺少必需字段

**解决方法：**
1. 验证 JSON 格式
2. 检查路径是否正确
3. 确保包含 name, version, description

### Q2: 命令无法识别

**可能原因：**
- 命令文件命名不正确
- 未在 `plugin.json` 中配置
- 命令名冲突

**解决方法：**
1. 检查文件命名（kebab-case）
2. 确认 `commands` 字段配置
3. 使用唯一的命令名

### Q3: 技能未触发

**可能原因：**
- 触发条件不明确
- 技能文件路径错误
- 技能描述不清晰

**解决方法：**
1. 明确定义触发条件
2. 检查 `skills` 字段配置
3. 优化技能描述

### Q4: 钩子不生效

**可能原因：**
- 钩子配置格式错误
- 事件类型不正确
- 条件表达式错误

**解决方法：**
1. 验证 JSON 格式
2. 检查事件类型
3. 测试条件表达式

### Q5: 性能问题

**可能原因：**
- 文档过大
- 钩子执行时间长
- 频繁触发

**解决方法：**
1. 控制文档大小（<500行）
2. 优化钩子逻辑
3. 使用条件加载

## 相关资源

- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)
- [插件开发指南](https://docs.anthropic.com/claude-code/plugins)
- [示例插件](https://github.com/anthropics/claude-code-examples)

---

**最后更新：** 2025-12-26
**维护者：** Trusta Team