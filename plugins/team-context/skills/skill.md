---
name: load-context
description: 当 AI 需要了解团队编码规范、架构设计、业务知识或工作流程来完成任务时，自动使用此 skill 加载相关上下文。适用场景：代码生成前加载编码规范、代码审查前加载规范标准、实现业务逻辑前加载业务知识、新人询问团队流程时加载工作流程文档。支持按类型过滤加载特定知识类别。
tags: ["knowledge", "context", "team"]
---

# 加载团队知识上下文

## 目的

将团队的研发知识库加载到当前对话上下文中，使 AI 能够基于团队的编码规范、架构设计、业务知识和工作流程来完成任务。

## 自动注入功能（v2.0 新增）

插件现在支持**智能自动注入**，在以下场景会自动加载相关团队规范：

### 自动注入场景

1. **代码编辑时（Write/Edit）**
   - 根据文件类型和路径自动推断需要的规范
   - 例如：编辑 `.tsx` 文件时自动加载前端编码规范和 React 架构设计

2. **计划模式（EnterPlanMode）**
   - 进入计划模式时自动加载架构设计、工作流程和业务知识
   - 确保制定的计划符合团队规范

### 标签推断规则

插件会根据以下信息智能推断需要加载的标签：

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

### 禁用自动注入

如果需要禁用自动注入，创建配置文件：

```bash
# 在项目根目录创建
.claude/team-context-config.json
```

内容：
```json
{
  "autoInject": false
}
```

## 手动加载（兼容旧版）

虽然插件支持自动注入，但你仍然可以手动加载特定知识：

### 加载所有知识

```bash
/load-context
```

### 按标签加载

```bash
# 加载编码规范
/load-context --type coding-standards

# 加载架构设计
/load-context --type architecture

# 加载业务知识
/load-context --type business

# 加载工作流程
/load-context --type workflow

# 加载多个类型（用逗号分隔）
/load-context --type coding-standards,architecture
```

## 标签体系（v2.0）

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

## 典型场景

### 场景 1：编辑前端组件（自动注入）

当你编辑 `src/features/auth/LoginForm.tsx` 时：
- 插件自动推断标签：`coding-standards, architecture.frontend, architecture.react, business.auth`
- 自动加载相关规范，无需手动调用

### 场景 2：进入计划模式（自动注入）

当你使用 EnterPlanMode 时：
- 插件自动加载：`architecture, workflow, business`
- 确保计划符合团队架构和流程规范

### 场景 3：手动加载特定规范

如果需要查看特定规范：

```bash
/load-context --type coding-standards.naming
```

然后询问 AI：
```
团队的命名约定是什么？
```

### 场景 4：代码审查

在审查代码前手动加载编码规范：

```bash
/load-context --type coding-standards
```

然后请求 AI：
```
请审查 src/services/userService.ts 是否符合团队规范
```

## 实现逻辑

1. **自动注入（PreToolUse Hook）**
   - 监听 Write/Edit/EnterPlanMode 工具调用
   - 根据文件路径和工具类型推断标签
   - 解析 `docs/team-context.md` 中的 YAML frontmatter
   - 匹配标签（支持精确匹配和前缀匹配）
   - 将匹配的章节注入到系统消息

2. **手动加载（Skill）**
   - 读取 `docs/team-context.md` 文件
   - 根据 `--type` 参数过滤章节
   - 将知识内容注入到当前对话上下文

## 性能优化

- 每个章节限制 100 行
- 总输出限制 10KB
- Hook 执行超时 10 秒
- 支持标签前缀匹配，减少重复加载

## 错误处理

- 如果知识文件不存在，静默失败，不影响正常操作
- 如果 YAML frontmatter 格式错误，跳过该章节
- 如果没有匹配的标签，不注入任何内容

## 注意事项

- 知识内容会消耗 token，插件已优化输出大小
- 自动注入的知识在当前工具调用中有效
- 如果知识文件更新，下次工具调用时会自动加载最新内容
- 可以通过配置文件禁用自动注入

---

## 执行指令

当此 Skill 被手动调用时，执行以下步骤：

1. 读取 `docs/team-context.md` 文件
2. 解析 `--type` 参数（如果有）
3. 根据标签过滤内容（支持一级和二级标签）
4. 将过滤后的内容作为系统消息注入
5. 向用户确认已加载的知识类型

