# load-context Skill 使用示例

本文档提供 `/load-context` Skill 的实际使用示例。

## 示例 1：前端组件开发

**场景：** 需要创建一个符合团队规范的 React 组件

**步骤：**

1. 加载前端相关知识：
```bash
/load-context --type coding-standards,architecture
```

2. 请求 AI 生成组件：
```
请创建一个用户登录表单组件，包含邮箱和密码输入框，以及提交按钮。
要求：
- 使用 TypeScript
- 使用 Tailwind CSS
- 包含表单验证
- 符合团队的命名和目录结构规范
```

**预期结果：**
- AI 会生成符合团队编码规范的代码
- 组件会放在正确的目录结构中
- 使用团队约定的技术栈

---

## 示例 2：API 接口开发

**场景：** 需要创建一个 RESTful API 接口

**步骤：**

1. 加载架构设计知识：
```bash
/load-context --type architecture
```

2. 请求 AI 创建 API：
```
请创建一个用户管理的 API 接口，包含 CRUD 操作。
```

**预期结果：**
- API 遵循 RESTful 规范
- 使用正确的 HTTP 方法和状态码
- 符合团队的 API 设计原则

---

## 示例 3：业务逻辑实现

**场景：** 需要实现订单创建的业务逻辑

**步骤：**

1. 加载业务知识：
```bash
/load-context --type business
```

2. 请求 AI 实现业务逻辑：
```
请实现订单创建的业务逻辑，包含所有必要的验证和错误处理。
```

**预期结果：**
- AI 会自动应用业务规则（如库存检查、用户登录验证）
- 订单状态设置为 `pending`
- 包含适当的错误处理

---

## 示例 4：代码审查

**场景：** 审查一段代码是否符合团队规范

**步骤：**

1. 加载编码规范：
```bash
/load-context --type coding-standards
```

2. 请求 AI 审查代码：
```
请审查以下代码是否符合团队规范：

\`\`\`typescript
function getUsr(id) {
  try {
    const usr = db.find(id);
    return usr;
  } catch (e) {
    console.log(e);
    return null;
  }
}
\`\`\`
```

**预期结果：**
- AI 会指出命名不规范（`getUsr` → `getUser`，`usr` → `user`）
- 指出缺少类型注解
- 指出错误处理不当（吞掉异常）

---

## 示例 5：新人学习

**场景：** 新成员想了解团队的工作流程

**步骤：**

1. 加载所有知识：
```bash
/load-context
```

2. 询问 AI：
```
团队的 Git 工作流是什么？如何创建和合并 Pull Request？
```

**预期结果：**
- AI 会详细解释团队的 Feature Branch 工作流
- 提供具体的命令示例
- 说明代码审查流程

---

## 示例 6：多类型组合

**场景：** 需要实现一个完整的功能模块

**步骤：**

1. 加载多个类型的知识：
```bash
/load-context --type coding-standards,architecture,business
```

2. 请求 AI 实现功能：
```
请实现一个完整的用户注册功能，包括：
- 前端注册表单
- 后端 API 接口
- 业务逻辑验证
- 数据库操作
```

**预期结果：**
- 前端代码符合编码规范和架构设计
- 后端 API 遵循 RESTful 规范
- 业务逻辑符合用户注册规则（邮箱唯一、密码强度、发送欢迎邮件）

---

## 最佳实践

### 1. 按需加载

只加载当前任务需要的知识类型，避免消耗过多 token：

```bash
# ✅ 好的做法
/load-context --type coding-standards

# ❌ 不必要的做法（如果只需要编码规范）
/load-context
```

### 2. 在任务开始前加载

在请求 AI 执行任务之前先加载知识：

```bash
# ✅ 正确顺序
/load-context --type architecture
"请创建一个 API 接口"

# ❌ 错误顺序
"请创建一个 API 接口"
/load-context --type architecture
```

### 3. 知识更新后重新加载

如果团队知识库更新了，记得重新加载：

```bash
# 编辑 docs/team-context.md 后
/load-context
```

### 4. 组合使用

根据任务复杂度组合多个类型：

```bash
# 简单任务
/load-context --type coding-standards

# 中等任务
/load-context --type coding-standards,architecture

# 复杂任务
/load-context --type coding-standards,architecture,business
```

---

## 常见问题

### Q1: 加载知识后会一直有效吗？

**A:** 是的，加载后的知识在当前对话中持续有效，直到对话结束或上下文被清空。

### Q2: 可以多次加载不同类型吗？

**A:** 可以，但建议一次性加载所有需要的类型，避免重复加载。

### Q3: 如何知道知识已经加载成功？

**A:** AI 会确认已加载的知识类型，例如："已加载编码规范和架构设计知识"。

### Q4: 知识文件很大会影响性能吗？

**A:** 会消耗 token，建议按需加载，并保持知识文件精简（每个规范 <200 字）。

### Q5: 可以在对话中途加载知识吗？

**A:** 可以，但建议在任务开始前加载，以确保 AI 从一开始就了解团队规范。
