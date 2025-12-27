# Team Context（团队知识上下文系统）v2.0

让 AI 研发助手了解和应用团队的编码规范、架构设计、业务知识和工作流程。

## 功能概述

团队知识上下文系统让 AI 能够自动了解和应用你的团队规范，包括：
- **编码规范**：命名约定、函数设计、错误处理、测试规范、样式规范
- **架构设计**：技术栈、目录结构、API 设计、前后端架构
- **业务知识**：核心概念、业务规则、认证授权、订单业务
- **工作流程**：Git 工作流、代码审查、发布流程、文档规范

## 核心优势

- ✅ **智能自动注入**：根据文件类型和路径自动加载相关规范
- ✅ **标签化管理**：使用 YAML frontmatter 标签系统，易于维护
- ✅ **精准匹配**：支持精确匹配和前缀匹配，减少噪声
- ✅ **Plan 模式支持**：进入计划模式时自动加载架构和流程规范
- ✅ **性能优化**：限制输出大小，避免 token 浪费
- ✅ **新人快速上手**：通过 AI 快速了解团队约定

## 安装

```bash
claude-code plugin install ./plugins/team-context
```

## v2.0 新特性

### 1. 智能标签推断

插件会根据文件类型、路径和工具类型自动推断需要加载的标签：

**文件扩展名：**
- `.tsx`, `.jsx` → 编码规范 + 前端架构 + React
- `.vue` → 编码规范 + 前端架构 + Vue
- `.ts`, `.js` → 编码规范（如在 api/service 目录则加载后端架构）
- `.py` → 编码规范 + 后端架构
- `.css`, `.scss` → 样式规范 + 前端架构
- `.test.*`, `.spec.*` → 测试规范 + 测试流程

**路径关键词：**
- `/auth/`, `/login/` → 认证业务知识
- `/order/`, `/payment/` → 订单业务知识
- `/component/`, `/ui/` → 前端架构
- `/test/`, `/spec/` → 测试规范
- `/utils/`, `/helpers/` → 工具函数规范

### 2. YAML Frontmatter 标签系统

每个章节使用 YAML frontmatter 定义标签，不再依赖固定章节编号：

```markdown
---
tags: [coding-standards, naming]
title: "命名约定"
priority: high
---

## 命名约定

**原则：** 使用清晰、描述性的命名...
```

### 3. Plan 模式自动注入

进入计划模式（EnterPlanMode）时，自动加载：
- `architecture` - 架构设计
- `workflow` - 工作流程
- `business` - 业务知识

确保制定的计划符合团队规范。

## 快速开始

### 1. 自定义团队知识

编辑 `docs/team-context.md` 文件，为每个章节添加标签：

```bash
# 编辑知识文件
vim docs/team-context.md

# 为每个章节添加 YAML frontmatter
---
tags: [coding-standards, naming]
title: "命名约定"
priority: high
---

## 命名约定
...
```

### 2. 自动注入（推荐）

插件会在以下场景自动注入相关规范：

**编辑代码时：**
```bash
# 编辑前端组件
vim src/features/auth/LoginForm.tsx
# 自动加载：coding-standards, architecture.frontend, architecture.react, business.auth
```

**进入计划模式时：**
```bash
# 使用 EnterPlanMode
# 自动加载：architecture, workflow, business
```

### 3. 手动加载（可选）

如果需要手动加载特定知识：

```bash
# 加载所有知识
/load-context

# 按标签加载
/load-context --type coding-standards
/load-context --type architecture
/load-context --type business
/load-context --type workflow

# 组合加载
/load-context --type coding-standards,architecture
```

### 4. 验证效果

加载知识后，请求 AI 生成代码：

```
请创建一个用户服务类，包含 CRUD 操作
```

AI 会自动应用你的团队规范！

## 使用场景

### 场景 1：编辑前端组件（自动注入）

```bash
# 编辑文件
vim src/features/auth/LoginForm.tsx

# 插件自动推断标签：
# - coding-standards
# - architecture.frontend
# - architecture.react
# - business.auth

# 然后请求 AI
"请优化这个登录表单的错误处理"
```

### 场景 2：进入计划模式（自动注入）

```bash
# 使用 EnterPlanMode
# 插件自动加载：architecture, workflow, business

# 然后制定计划
"帮我规划用户认证功能的实现"
```

### 场景 3：代码审查（手动加载）

```bash
/load-context --type coding-standards
"请审查 src/services/userService.ts 是否符合规范"
```

### 场景 4：业务逻辑（手动加载）

```bash
/load-context --type business
"请实现订单创建的业务逻辑"
```

## 标签体系

### 一级标签

- `coding-standards` - 编码规范
- `architecture` - 架构设计
- `business` - 业务知识
- `workflow` - 工作流程

### 二级标签（细分）

**编码规范：**
- `coding-standards.naming` - 命名约定
- `coding-standards.functions` - 函数设计
- `coding-standards.errors` - 错误处理
- `coding-standards.testing` - 测试规范
- `coding-standards.styling` - 样式规范
- `coding-standards.utils` - 工具函数规范

**架构设计：**
- `architecture.frontend` - 前端架构
- `architecture.backend` - 后端架构
- `architecture.api` - API 设计
- `architecture.react` - React 相关
- `architecture.vue` - Vue 相关
- `architecture.config` - 配置管理

**业务知识：**
- `business.auth` - 认证授权
- `business.order` - 订单业务
- `business.user` - 用户业务

**工作流程：**
- `workflow.git` - Git 工作流
- `workflow.review` - 代码审查
- `workflow.testing` - 测试流程
- `workflow.deployment` - 部署流程
- `workflow.documentation` - 文档规范

## 知识文件结构

`docs/team-context.md` 使用 YAML frontmatter 标签系统：

```markdown
---
version: "2.0.0"
last_updated: "2025-12-27"
description: "团队研发知识库"
---

# 团队研发知识库

---
tags: [coding-standards, naming]
title: "命名约定"
priority: high
---

## 命名约定

**原则：** 使用清晰、描述性的命名...

---
tags: [architecture, frontend, react]
title: "前端技术栈"
priority: high
---

## 前端技术栈

**前端：** React 18 + TypeScript...
```

每个规范包含：
- **YAML frontmatter**：标签、标题、优先级
- **原则**：简洁描述
- **正例**：好的代码示例
- **反例**：不好的代码示例（标记 ❌）

## Hook 自动注入机制

插件内置了 PreToolUse Hook，会在以下场景自动注入相关的团队规范：

### 自动注入规则

**工具类型：**
- `Write` / `Edit` → 根据文件类型和路径推断标签
- `EnterPlanMode` → 加载 architecture, workflow, business

**文件类型：**
- `.tsx/.jsx` → coding-standards, architecture.frontend, architecture.react
- `.vue` → coding-standards, architecture.frontend, architecture.vue
- `.ts/.js` → coding-standards（+ 路径推断）
- `.py` → coding-standards, architecture.backend
- `.css/.scss` → coding-standards.styling, architecture.frontend
- `.test.*/.spec.*` → coding-standards.testing, workflow.testing

**路径关键词：**
- `/auth/` → business.auth
- `/order/` → business.order
- `/api/`, `/service/` → architecture.api, business
- `/component/`, `/ui/` → architecture.frontend
- `/utils/`, `/helpers/` → coding-standards.utils

### 配置自动注入

创建 `.claude/team-context-config.json`：

```json
{
  "autoInject": true
}
```

设置为 `false` 可禁用自动注入，改用手动 `/load-context` 方式。

## 维护指南

### 更新知识文件

```bash
# 1. 编辑知识文件
vim docs/team-context.md

# 2. 为新章节添加 YAML frontmatter
---
tags: [coding-standards, security]
title: "安全规范"
priority: high
---

## 安全规范
...

# 3. 更新 version 和 last_updated 字段
# 4. 提交到 Git
git add docs/team-context.md
git commit -m "docs: add security standards"
```

### 版本管理

- **补丁版本（0.2.x）**：修正错误、补充示例
- **次版本（0.x.0）**：添加新章节、新规范
- **主版本（x.0.0）**：重大变更、架构调整

## 最佳实践

1. **使用标签系统**：为每个章节添加清晰的标签
2. **保持知识精简**：每个规范 <200 字，使用代码示例
3. **定期更新**：技术栈变化时更新，发现新的最佳实践时添加
4. **利用自动注入**：让插件自动加载相关规范，减少手动操作
5. **标签层次化**：使用二级标签（如 `coding-standards.naming`）细分知识

## 常见问题

**Q: 知识文件可以拆分成多个文件吗？**
A: 可以，但当前推荐单文件管理（适合小团队）。如果知识量很大，可以按主题拆分。

**Q: 如何让 AI 自动应用规范，而不是每次手动加载？**
A: 插件已内置 Hook 机制，会在代码生成和计划模式前自动注入规范。默认启用，可通过配置文件禁用。

**Q: 如何禁用自动注入功能？**
A: 在项目根目录创建 `.claude/team-context-config.json` 文件，设置 `{"autoInject": false}`。

**Q: 知识更新后需要重新加载吗？**
A: 如果使用 `/load-context` 手动加载，需要重新运行。如果使用 Hook 自动注入，会自动读取最新内容。

**Q: 会消耗很多 token 吗？**
A: v2.0 优化了标签匹配机制，只加载相关章节。每个章节限制 100 行，总输出限制 10KB。

**Q: 如何调试标签推断？**
A: 可以查看 Hook 输出的系统消息，会显示推断的标签和加载的章节。

## 版本历史

- **v0.2.0** (2025-12-27)
  - 添加 YAML frontmatter 标签系统
  - 实现智能标签推断
  - 支持 EnterPlanMode 自动注入
  - 优化性能和容错处理
  - 支持标签前缀匹配

- **v0.1.0** (2024-12-26)
  - 初始版本
  - 支持手动加载团队知识
  - 内置 Hook 自动注入机制
  - 支持按类型加载知识

## 许可证

MIT License

## 贡献

欢迎提出改进建议！请访问 [主仓库](../../README.md) 了解贡献指南。
