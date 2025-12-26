---
name: load-context
description: 当 AI 需要了解团队编码规范、架构设计、业务知识或工作流程来完成任务时，自动使用此 skill 加载相关上下文。适用场景：代码生成前加载编码规范、代码审查前加载规范标准、实现业务逻辑前加载业务知识、新人询问团队流程时加载工作流程文档。支持按类型过滤加载特定知识类别。
tags: ["knowledge", "context", "team"]
---

# 加载团队知识上下文

## 目的

将团队的研发知识库加载到当前对话上下文中，使 AI 能够基于团队的编码规范、架构设计、业务知识和工作流程来完成任务。

## 何时使用

- **代码生成前** - 加载编码规范和架构设计，确保生成的代码符合团队标准
- **代码审查时** - 加载编码规范，检查代码是否符合团队要求
- **实现业务逻辑前** - 加载业务知识，确保实现符合业务规则
- **回答团队流程问题** - 加载工作流程文档，为新成员提供指导

## 使用方法

### 加载所有知识

```bash
/load-context
```

### 按类型加载

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

## 参数说明

- `--type` (可选): 指定要加载的知识类型
  - `coding-standards` - 编码规范
  - `architecture` - 架构设计
  - `business` - 业务知识
  - `workflow` - 工作流程
  - 不指定则加载所有内容

## 典型场景

### 场景 1：代码生成

在生成代码前加载相关规范：

```bash
/load-context --type coding-standards,architecture
```

然后请求 AI：
```
请创建一个用户服务类，包含 CRUD 操作
```

### 场景 2：代码审查

在审查代码前加载编码规范：

```bash
/load-context --type coding-standards
```

然后请求 AI：
```
请审查 src/services/userService.ts 是否符合团队规范
```

### 场景 3：业务逻辑实现

在实现业务逻辑前加载业务知识：

```bash
/load-context --type business
```

然后请求 AI：
```
请实现订单创建的业务逻辑，确保符合业务规则
```

### 场景 4：新人学习

新成员查询团队规范：

```bash
/load-context
```

然后询问 AI：
```
团队的 Git 工作流是什么？
```

## 实现逻辑

1. 读取 `docs/team-context.md` 文件
2. 如果指定了 `--type` 参数，过滤相关章节
3. 将知识内容注入到当前对话上下文
4. 提示已加载的知识类型

## 错误处理

- 如果知识文件不存在，提示创建
- 如果指定的类型无效，显示可用类型列表
- 如果文件格式错误，尝试容错解析

## 注意事项

- 知识内容会消耗 token，建议按需加载
- 加载后的知识在当前对话中持续有效
- 如果知识文件更新，需要重新加载

---

## 执行指令

当此 Skill 被调用时，执行以下步骤：

1. 读取 `docs/team-context.md` 文件
2. 解析 `--type` 参数（如果有）
3. 根据类型过滤内容：
   - `coding-standards` → 第 1 章节
   - `architecture` → 第 2 章节
   - `business` → 第 3 章节
   - `workflow` → 第 4 章节
4. 将过滤后的内容作为系统消息注入
5. 向用户确认已加载的知识类型

