# 团队知识上下文系统 - 快速开始

5 分钟快速上手指南，让 AI 研发助手了解你的团队规范。

## 第 1 步：了解系统结构（1 分钟）

系统包含以下文件：

```
.claude/
├── team-context.md              # 团队知识库（核心文件）
├── skills/
│   └── load-context/            # 加载知识的 Skill
│       ├── skill.md
│       └── examples/usage.md
└── docs/
    ├── quick-start.md           # 本文件
    └── team-context-guide.md    # 详细使用指南
```

## 第 2 步：查看知识文件（1 分钟）

打开 `docs/team-context.md`，你会看到：

- **第 1 章：编码规范** - 命名约定、函数设计、错误处理
- **第 2 章：架构设计** - 技术栈、目录结构、API 设计
- **第 3 章：业务知识** - 核心概念、业务规则
- **第 4 章：工作流程** - Git 工作流、代码审查、发布流程

## 第 3 步：自定义团队知识（2 分钟）

编辑 `docs/team-context.md`，替换为你的团队实际规范：

1. 更新技术栈（如果不同）
2. 添加你的业务术语和规则
3. 调整编码规范（如果有特殊要求）
4. 更新工作流程

**提示：** 保持每个规范简洁（<200 字），使用代码示例而非文字描述。

## 第 4 步：使用 Skill 加载知识（1 分钟）

在 Claude Code 中使用 `/load-context` 命令：

```bash
# 加载所有知识
/load-context

# 或按需加载
/load-context --type coding-standards,architecture
```

## 第 5 步：验证效果（立即）

加载知识后，请求 AI 生成代码：

```
请创建一个用户服务类，包含 CRUD 操作
```

AI 会自动应用你的团队规范！

---

## 常见使用场景

### 场景 1：代码生成

```bash
/load-context --type coding-standards,architecture
"请创建一个登录表单组件"
```

### 场景 2：代码审查

```bash
/load-context --type coding-standards
"请审查 src/services/userService.ts 是否符合规范"
```

### 场景 3：业务逻辑

```bash
/load-context --type business
"请实现订单创建的业务逻辑"
```

### 场景 4：新人学习

```bash
/load-context
"团队的 Git 工作流是什么？"
```

---

## 下一步

- 阅读 [详细使用指南](./team-context-guide.md) 了解更多功能
- 查看 [使用示例](../skills/load-context/examples/usage.md) 学习最佳实践
- 定期更新 `team-context.md` 保持知识最新

---

## 常见问题

**Q: 知识文件可以拆分成多个文件吗？**
A: 可以，但当前推荐单文件管理（适合小团队）。如果知识量很大，可以按主题拆分。

**Q: 如何让 AI 自动应用规范，而不是每次手动加载？**
A: 可以使用 Hook 机制（见详细指南），在代码生成前自动注入规范。

**Q: 知识更新后需要重新加载吗？**
A: 是的，编辑 `team-context.md` 后需要重新运行 `/load-context`。

**Q: 会消耗很多 token 吗？**
A: 按需加载可以控制 token 消耗。建议只加载当前任务需要的知识类型。

---

## 获取帮助

- 查看 [详细使用指南](./team-context-guide.md)
- 查看 [使用示例](../skills/load-context/examples/usage.md)
- 在团队内部分享使用经验
