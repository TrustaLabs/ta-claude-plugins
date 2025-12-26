# Team Context（团队知识上下文系统）

让 AI 研发助手了解和应用团队的编码规范、架构设计、业务知识和工作流程。

## 功能概述

团队知识上下文系统让 AI 能够自动了解和应用你的团队规范，包括：
- **编码规范**：命名约定、函数设计、错误处理
- **架构设计**：技术栈、目录结构、API 设计
- **业务知识**：核心概念、业务规则
- **工作流程**：Git 工作流、代码审查、发布流程

## 核心优势

- ✅ **自动应用规范**：AI 生成的代码自动符合团队标准
- ✅ **减少重复解释**：无需每次都说明团队规范
- ✅ **新人快速上手**：通过 AI 快速了解团队约定
- ✅ **知识集中管理**：单一信息源，易于维护

## 安装

```bash
claude-code plugin install ./plugins/team-context
```

## 快速开始

### 1. 自定义团队知识

编辑 `docs/team-context.md` 文件，替换为你的团队实际规范：

```bash
# 编辑知识文件
vim docs/team-context.md

# 更新内容：
# - 技术栈
# - 业务术语
# - 编码规范
# - 工作流程
```

### 2. 使用 Skill 加载知识

在 Claude Code 中使用 `/ta-init` 命令：

```bash
# 加载所有知识
/ta-init

# 按需加载
/ta-init --type coding-standards
/ta-init --type architecture
/ta-init --type business
/ta-init --type workflow

# 组合加载
/ta-init --type coding-standards,architecture
```

### 3. 验证效果

加载知识后，请求 AI 生成代码：

```
请创建一个用户服务类，包含 CRUD 操作
```

AI 会自动应用你的团队规范！

## 使用场景

### 场景 1：代码生成

```bash
/ta-init --type coding-standards,architecture
"请创建一个登录表单组件"
```

### 场景 2：代码审查

```bash
/ta-init --type coding-standards
"请审查 src/services/userService.ts 是否符合规范"
```

### 场景 3：业务逻辑

```bash
/ta-init --type business
"请实现订单创建的业务逻辑"
```

### 场景 4：新人学习

```bash
/ta-init
"团队的 Git 工作流是什么?"
```

## 知识文件结构

`docs/team-context.md` 包含以下章节：

```markdown
## 1. 编码规范
### 1.1 命名约定
### 1.2 函数设计
### 1.3 错误处理

## 2. 架构设计
### 2.1 技术栈
### 2.2 目录结构
### 2.3 API 设计

## 3. 业务知识
### 3.1 核心业务概念
### 3.2 业务规则

## 4. 工作流程
### 4.1 Git 工作流
### 4.2 代码审查
### 4.3 发布流程
```

每个规范包含：
- **原则**：简洁描述
- **正例**：好的代码示例
- **反例**：不好的代码示例（标记 ❌）

## Hook 自动注入机制

插件内置了 PreToolUse Hook，会在代码生成前自动注入相关的团队规范：

### 自动注入规则

- `.ts/.tsx/.js/.jsx` 文件 → 加载编码规范 + 架构设计
- `.py` 文件 → 加载编码规范
- 包含 `test` 或 `spec` 的文件 → 加载编码规范
- 包含 `api` 或 `service` 的文件 → 加载编码规范 + 架构设计 + 业务知识

### 配置自动注入

创建 `.claude/team-context-config.json`：

```json
{
  "autoInject": true
}
```

设置为 `false` 可禁用自动注入，改用手动 `/ta-init` 方式。

## 维护指南

### 更新知识文件

```bash
# 1. 编辑知识文件
vim docs/team-context.md

# 2. 更新 last_updated 字段
# 3. 提交到 Git
git add docs/team-context.md
git commit -m "docs: update team context"
```

### 版本管理

- **补丁版本（1.0.x）**：修正错误、补充示例
- **次版本（1.x.0）**：添加新章节、新规范
- **主版本（x.0.0）**：重大变更、架构调整

## 最佳实践

1. **按需加载**：只加载当前任务需要的知识类型
2. **任务开始前加载**：在请求 AI 之前先加载知识
3. **保持知识精简**：每个规范 <200 字，使用代码示例
4. **定期更新**：技术栈变化时更新，发现新的最佳实践时添加

## 常见问题

**Q: 知识文件可以拆分成多个文件吗？**
A: 可以，但当前推荐单文件管理（适合小团队）。如果知识量很大，可以按主题拆分。

**Q: 如何让 AI 自动应用规范，而不是每次手动加载？**
A: 插件已内置 Hook 机制，会在代码生成前自动注入规范。默认启用，可通过配置文件禁用。

**Q: 如何禁用自动注入功能？**
A: 在项目根目录创建 `.claude/team-context-config.json` 文件，设置 `{"autoInject": false}`。

**Q: 知识更新后需要重新加载吗？**
A: 如果使用 `/ta-init` 手动加载，需要重新运行。如果使用 Hook 自动注入，会自动读取最新内容。

**Q: 会消耗很多 token 吗？**
A: Hook 机制会根据文件类型智能加载相关规范，避免加载不必要的内容。手动加载时建议按需加载。

## 版本历史

- **v0.1.0** (2024-12-26)
  - 初始版本
  - 支持手动加载团队知识
  - 内置 Hook 自动注入机制
  - 支持按类型加载知识

## 许可证

MIT License

## 贡献

欢迎提出改进建议！请访问 [主仓库](../../README.md) 了解贡献指南。
