# 团队知识上下文系统 - 详细使用指南

本指南详细介绍如何使用和维护团队知识上下文系统。

## 目录

1. [系统概述](#系统概述)
2. [核心概念](#核心概念)
3. [使用方法](#使用方法)
4. [知识文件编写](#知识文件编写)
5. [高级功能](#高级功能)
6. [维护指南](#维护指南)
7. [最佳实践](#最佳实践)
8. [故障排除](#故障排除)

---

## 系统概述

### 什么是团队知识上下文系统？

这是一个基于 Claude Code 的知识管理系统，让 AI 研发助手能够了解和应用团队的：
- 编码规范（代码风格、命名约定）
- 架构设计（技术栈、设计模式）
- 业务知识（领域概念、业务规则）
- 工作流程（开发流程、发布流程）

### 核心优势

- **自动应用规范：** AI 生成的代码自动符合团队标准
- **减少重复解释：** 无需每次都说明团队规范
- **新人快速上手：** 通过 AI 快速了解团队约定
- **知识集中管理：** 单一信息源，易于维护

### 系统架构

```
.claude/
├── team-context.md              # 知识库（核心）
├── skills/
│   └── load-context/            # 加载知识的 Skill
│       ├── skill.md             # Skill 定义
│       └── examples/usage.md    # 使用示例
├── hooks/                       # Hook 机制（可选）
│   └── auto-apply-standards.js  # 自动应用规范
└── docs/
    ├── quick-start.md           # 快速开始
    └── team-context-guide.md    # 本文件
```

---

## 核心概念

### 知识文件 (`team-context.md`)

这是系统的核心，包含所有团队知识。文件结构：

```markdown
---
version: "1.0.0"
last_updated: "2025-12-26"
tags: ["coding-standards", "architecture", "business", "workflow"]
---

# 团队研发知识库

## 1. 编码规范
### 1.1 命名约定
### 1.2 函数设计
...

## 2. 架构设计
### 2.1 技术栈
### 2.2 目录结构
...

## 3. 业务知识
### 3.1 核心业务概念
### 3.2 业务规则
...

## 4. 工作流程
### 4.1 Git 工作流
### 4.2 代码审查
...
```

### Skill 机制

`/load-context` Skill 负责：
1. 读取知识文件
2. 根据参数过滤内容
3. 注入到当前对话上下文

### Hook 机制（可选）

Hook 可以在特定事件（如代码生成）时自动注入规范，无需手动调用 Skill。

---

## 使用方法

### 基本用法

#### 1. 加载所有知识

```bash
/load-context
```

适用场景：
- 新人学习团队规范
- 不确定需要哪些知识
- 实现复杂功能

#### 2. 按类型加载

```bash
# 加载编码规范
/load-context --type coding-standards

# 加载架构设计
/load-context --type architecture

# 加载业务知识
/load-context --type business

# 加载工作流程
/load-context --type workflow
```

#### 3. 组合加载

```bash
# 加载多个类型
/load-context --type coding-standards,architecture

# 前端开发常用组合
/load-context --type coding-standards,architecture

# 业务逻辑开发常用组合
/load-context --type coding-standards,business
```

### 使用流程

**标准流程：**

1. **加载知识** → 2. **请求 AI** → 3. **验证结果**

**示例：**

```bash
# 步骤 1：加载知识
/load-context --type coding-standards,architecture

# 步骤 2：请求 AI
"请创建一个用户服务类，包含 CRUD 操作"

# 步骤 3：验证生成的代码是否符合规范
```

---

## 知识文件编写

### 文件结构

#### YAML Frontmatter

```yaml
---
version: "1.0.0"           # 语义化版本号
last_updated: "2025-12-26" # 最后更新日期
tags: ["coding-standards", "architecture", "business", "workflow"]
description: "团队研发知识库"
---
```

#### 章节组织

```markdown
## 1. 编码规范
### 1.1 子主题
**原则：** 简洁描述原则

**正例：**
\`\`\`typescript
// 好的代码示例
\`\`\`

**反例：**
\`\`\`typescript
// ❌ 不好的代码示例
\`\`\`
```

### 编写原则

#### 1. 简洁明了

- 每个规范控制在 200 字以内
- 使用代码示例而非文字描述
- 避免冗长的解释

**好的示例：**
```markdown
### 命名约定

**原则：** 使用 camelCase 命名变量和函数。

**正例：**
\`\`\`typescript
const userName = "Alice";
function getUserProfile() {}
\`\`\`

**反例：**
\`\`\`typescript
const user_name = "Alice"; // ❌
\`\`\`
```

**不好的示例：**
```markdown
### 命名约定

在我们的团队中，我们遵循 JavaScript 社区的最佳实践，使用 camelCase 来命名变量和函数。这种命名方式的优点是...（冗长的解释）
```

#### 2. 正例 + 反例

每个规范都应包含：
- **原则：** 简短说明
- **正例：** 好的代码示例
- **反例：** 不好的代码示例（标记 ❌）

#### 3. 实用性优先

- 关注实际开发中常见的问题
- 避免过于理论化的内容
- 提供可直接应用的指导

#### 4. 保持更新

- 定期审查和更新内容
- 删除过时的规范
- 添加新的最佳实践

---

## 高级功能

### 1. 多文件支持（扩展）

如果知识量很大，可以拆分为多个文件：

```
.claude/
├── team-context/
│   ├── coding-standards.md
│   ├── architecture.md
│   ├── business.md
│   └── workflow.md
└── skills/
    └── load-context/
        └── skill.md  # 修改为读取多个文件
```

### 2. Hook 自动注入（可选）

创建 `.claude/hooks/auto-apply-standards.js`：

```javascript
// PreToolUse Hook
module.exports = {
  event: 'PreToolUse',
  filter: (tool) => ['Write', 'Edit'].includes(tool.name),
  handler: async (context) => {
    const { tool, filePath } = context;

    // 根据文件类型加载相关规范
    const ext = filePath.split('.').pop();
    let type = 'coding-standards';

    if (['ts', 'tsx', 'jsx'].includes(ext)) {
      type = 'coding-standards,architecture';
    } else if (['py'].includes(ext)) {
      type = 'coding-standards';
    }

    // 读取并注入知识
    const knowledge = await loadContext(type);
    context.addSystemMessage(knowledge);
  }
};
```

### 3. 知识版本管理

在 frontmatter 中记录版本历史：

```yaml
---
version: "1.2.0"
last_updated: "2025-12-26"
changelog:
  - version: "1.2.0"
    date: "2025-12-26"
    changes: "添加 API 设计规范"
  - version: "1.1.0"
    date: "2025-12-20"
    changes: "更新技术栈为 React 18"
  - version: "1.0.0"
    date: "2025-12-15"
    changes: "初始版本"
---
```

### 4. 标签系统

使用标签实现更灵活的过滤：

```yaml
---
tags: ["frontend", "backend", "react", "typescript", "api"]
---
```

然后在 Skill 中支持按标签过滤：

```bash
/load-context --tags frontend,react
```

---

## 维护指南

### 更新流程

#### 1. 日常更新

```bash
# 1. 编辑知识文件
vim docs/team-context.md

# 2. 更新 last_updated 字段
# 3. 提交到 Git
git add docs/team-context.md
git commit -m "docs: update team context"
```

#### 2. 版本更新

**补丁版本（1.0.x）：** 修正错误、补充示例
```yaml
version: "1.0.1"
```

**次版本（1.x.0）：** 添加新章节、新规范
```yaml
version: "1.1.0"
```

**主版本（x.0.0）：** 重大变更、架构调整
```yaml
version: "2.0.0"
```

### 审查周期

建议定期审查知识文件：

- **每月审查：** 检查是否有过时内容
- **季度审查：** 评估是否需要添加新规范
- **年度审查：** 全面评估和重构

### 团队协作

#### 方式 1：直接编辑（小团队）

- 团队成员直接编辑 `team-context.md`
- 提交到 Git
- 无需审批流程

#### 方式 2：PR 审核（大团队）

- 创建功能分支
- 编辑知识文件
- 创建 Pull Request
- 团队审查后合并

---

## 最佳实践

### 1. 按需加载

只加载当前任务需要的知识类型：

```bash
# ✅ 好的做法
/load-context --type coding-standards

# ❌ 不必要（如果只需要编码规范）
/load-context
```

### 2. 任务开始前加载

在请求 AI 之前先加载知识：

```bash
# ✅ 正确顺序
/load-context --type architecture
"请创建一个 API 接口"

# ❌ 错误顺序
"请创建一个 API 接口"
/load-context --type architecture
```

### 3. 保持知识精简

- 每个规范 <200 字
- 使用代码示例
- 删除冗余内容

### 4. 定期更新

- 技术栈变化时更新
- 发现新的最佳实践时添加
- 规范过时时删除

### 5. 团队共识

- 知识文件应反映团队共识
- 重大变更前讨论
- 新成员入职时介绍

---

## 故障排除

### 问题 1：知识文件不存在

**症状：** 运行 `/load-context` 时提示文件不存在

**解决方案：**
```bash
# 检查文件是否存在
ls docs/team-context.md

# 如果不存在，从模板创建
# 文件已存在于 docs/team-context.md
```

### 问题 2：YAML 格式错误

**症状：** 知识文件无法解析

**解决方案：**
- 检查 frontmatter 的 `---` 标记
- 验证 YAML 语法（使用在线工具）
- 确保缩进正确

### 问题 3：知识未生效

**症状：** 加载知识后 AI 仍不遵循规范

**可能原因：**
1. 知识描述不够清晰
2. 知识与请求冲突
3. 知识被其他指令覆盖

**解决方案：**
- 使用更明确的代码示例
- 在请求中强调"遵循团队规范"
- 检查是否有其他冲突的指令

### 问题 4：Token 消耗过多

**症状：** 加载知识后 token 消耗显著增加

**解决方案：**
- 按需加载，不要加载所有知识
- 精简知识内容
- 考虑拆分为多个文件

### 问题 5：多人编辑冲突

**症状：** Git 合并时出现冲突

**解决方案：**
- 拉取最新代码后再编辑
- 使用 PR 流程避免直接推送
- 手动解决冲突

---

## 附录

### A. 知识类型映射

| 类型 | 对应章节 | 适用场景 |
|------|---------|---------|
| `coding-standards` | 第 1 章 | 代码生成、代码审查 |
| `architecture` | 第 2 章 | 架构设计、技术选型 |
| `business` | 第 3 章 | 业务逻辑实现 |
| `workflow` | 第 4 章 | 流程咨询、新人学习 |

### B. 常用命令速查

```bash
# 加载所有知识
/load-context

# 加载编码规范
/load-context --type coding-standards

# 加载架构设计
/load-context --type architecture

# 加载业务知识
/load-context --type business

# 加载工作流程
/load-context --type workflow

# 组合加载
/load-context --type coding-standards,architecture
```

### C. 文件路径速查

```
docs/team-context.md                          # 知识库
.claude/skills/load-context/skill.md             # Skill 定义
.claude/skills/load-context/examples/usage.md    # 使用示例
.claude/docs/quick-start.md                      # 快速开始
.claude/docs/team-context-guide.md               # 本文件
```

---

## 获取帮助

- 查看 [快速开始指南](./quick-start.md)
- 查看 [使用示例](../skills/load-context/examples/usage.md)
- 在团队内部分享使用经验
- 向团队技术负责人反馈问题

---

**最后更新：** 2025-12-26
**版本：** 1.0.0
