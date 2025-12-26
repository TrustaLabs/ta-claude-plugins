---
version: "1.0.0"
last_updated: "2025-12-26"
tags: ["coding-standards", "architecture", "business", "workflow"]
description: "团队研发知识库 - 包含编码规范、架构设计、业务知识和工作流程"
---

# 团队研发知识库

本文档包含团队的研发约定、背景知识、业务知识等，供 AI 研发助手参考。

## 1. 编码规范

### 1.1 命名约定

**原则：** 使用清晰、描述性的命名，遵循语言惯例。

**正例：**
```typescript
// 变量使用 camelCase
const userProfile = getUserProfile();

// 常量使用 UPPER_SNAKE_CASE
const MAX_RETRY_COUNT = 3;

// 类使用 PascalCase
class UserService {}

// 接口使用 PascalCase，可选 I 前缀
interface IUserRepository {}
```

**反例：**
```typescript
// ❌ 不清晰的缩写
const usrPrf = getUP();

// ❌ 不一致的命名风格
const Max_Retry_Count = 3;

// ❌ 无意义的命名
class Manager {}
```

---

### 1.2 函数设计

**原则：** 函数应该单一职责，参数不超过 3 个，避免副作用。

**正例：**
```typescript
// 单一职责，清晰的输入输出
function calculateTotalPrice(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// 使用对象参数避免参数过多
function createUser(params: {
  name: string;
  email: string;
  role: UserRole;
}): User {
  // ...
}
```

**反例：**
```typescript
// ❌ 职责不清晰，有副作用
function processUser(name: string, email: string, role: string, sendEmail: boolean) {
  const user = createUser(name, email, role);
  saveToDatabase(user);
  if (sendEmail) {
    sendWelcomeEmail(user);
  }
  updateCache(user);
  return user;
}
```

---

### 1.3 错误处理

**原则：** 使用明确的错误类型，提供有用的错误信息，避免吞掉异常。

**正例：**
```typescript
class UserNotFoundError extends Error {
  constructor(userId: string) {
    super(`User not found: ${userId}`);
    this.name = 'UserNotFoundError';
  }
}

async function getUser(userId: string): Promise<User> {
  const user = await db.users.findById(userId);
  if (!user) {
    throw new UserNotFoundError(userId);
  }
  return user;
}
```

**反例：**
```typescript
// ❌ 吞掉异常
async function getUser(userId: string): Promise<User | null> {
  try {
    return await db.users.findById(userId);
  } catch (error) {
    console.log('Error:', error);
    return null;
  }
}
```

---

## 2. 架构设计

### 2.1 技术栈

**前端：**
- React 18 + TypeScript
- 状态管理：Zustand
- 样式：Tailwind CSS
- 构建工具：Vite

**后端：**
- Node.js + Express
- 数据库：PostgreSQL
- ORM：Prisma
- 认证：JWT

---

### 2.2 目录结构

**原则：** 按功能模块组织，而非按文件类型。

**正例：**
```
src/
├── features/
│   ├── auth/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── services/
│   │   └── types.ts
│   └── user/
│       ├── components/
│       ├── hooks/
│       └── services/
├── shared/
│   ├── components/
│   ├── hooks/
│   └── utils/
└── app.tsx
```

**反例：**
```
src/
├── components/
│   ├── AuthForm.tsx
│   ├── UserProfile.tsx
│   └── ...
├── hooks/
│   ├── useAuth.ts
│   ├── useUser.ts
│   └── ...
└── services/
    ├── authService.ts
    └── userService.ts
```

---

### 2.3 API 设计

**原则：** 遵循 RESTful 规范，使用语义化的 HTTP 方法和状态码。

**正例：**
```typescript
// GET /api/users/:id - 获取用户
router.get('/users/:id', async (req, res) => {
  const user = await userService.getById(req.params.id);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }
  res.json(user);
});

// POST /api/users - 创建用户
router.post('/users', async (req, res) => {
  const user = await userService.create(req.body);
  res.status(201).json(user);
});

// PUT /api/users/:id - 更新用户
router.put('/users/:id', async (req, res) => {
  const user = await userService.update(req.params.id, req.body);
  res.json(user);
});

// DELETE /api/users/:id - 删除用户
router.delete('/users/:id', async (req, res) => {
  await userService.delete(req.params.id);
  res.status(204).send();
});
```

---

## 3. 业务知识

### 3.1 核心业务概念

**用户角色：**
- **管理员（Admin）：** 拥有所有权限，可以管理用户和系统配置
- **普通用户（User）：** 可以使用基本功能，查看和编辑自己的数据
- **访客（Guest）：** 只能查看公开内容，无法编辑

**订单状态：**
- `pending` - 待支付
- `paid` - 已支付
- `processing` - 处理中
- `shipped` - 已发货
- `delivered` - 已送达
- `cancelled` - 已取消

---

### 3.2 业务规则

**规则 1：用户注册**
- 邮箱必须唯一
- 密码长度至少 8 位，包含字母和数字
- 注册成功后自动发送欢迎邮件

**规则 2：订单创建**
- 用户必须登录才能创建订单
- 订单金额必须大于 0
- 库存不足时不允许创建订单

**规则 3：权限控制**
- 用户只能查看和编辑自己的数据
- 管理员可以查看所有用户的数据
- 删除操作需要二次确认

---

## 4. 工作流程

### 4.1 Git 工作流

**原则：** 使用 Feature Branch 工作流，保持主分支稳定。

**流程：**
1. 从 `main` 分支创建功能分支：`git checkout -b feature/user-auth`
2. 在功能分支上开发和提交：`git commit -m "feat: add user authentication"`
3. 推送到远程：`git push origin feature/user-auth`
4. 创建 Pull Request，等待代码审查
5. 审查通过后合并到 `main`
6. 删除功能分支：`git branch -d feature/user-auth`

**提交信息规范：**
- `feat:` - 新功能
- `fix:` - 修复 bug
- `docs:` - 文档更新
- `refactor:` - 重构代码
- `test:` - 添加测试
- `chore:` - 构建工具或依赖更新

---

### 4.2 代码审查

**原则：** 所有代码必须经过至少一人审查才能合并。

**审查清单：**
- [ ] 代码符合编码规范
- [ ] 函数和变量命名清晰
- [ ] 有适当的错误处理
- [ ] 有必要的注释（复杂逻辑）
- [ ] 没有明显的性能问题
- [ ] 没有安全漏洞（如 SQL 注入、XSS）
- [ ] 测试覆盖关键路径

---

### 4.3 发布流程

**原则：** 使用语义化版本号，自动化部署。

**流程：**
1. 确保所有测试通过：`npm test`
2. 更新版本号：`npm version patch/minor/major`
3. 推送标签：`git push --tags`
4. CI/CD 自动构建和部署
5. 验证生产环境功能正常
6. 发布 Release Notes

---

## 5. 如何使用本文档

### 5.1 AI 研发助手使用

**场景 1：代码生成**
```bash
# 加载编码规范和架构设计
/load-context --type frontend,architecture

# 然后请求 AI 生成代码
"请创建一个用户登录组件"
```

**场景 2：代码审查**
```bash
# 加载编码规范
/load-context --type coding-standards

# 然后请求 AI 审查代码
"请审查这段代码是否符合团队规范"
```

**场景 3：业务逻辑实现**
```bash
# 加载业务知识
/load-context --type business

# 然后请求 AI 实现业务逻辑
"请实现订单创建的业务逻辑"
```

### 5.2 更新本文档

1. 直接编辑本文件
2. 更新 `last_updated` 字段
3. 如果有重大变更，更新 `version` 字段
4. 提交到 Git：`git commit -m "docs: update team context"`

---

## 6. 维护指南

### 6.1 何时更新

- 团队采用新的编码规范
- 技术栈发生变化
- 业务规则调整
- 工作流程优化

### 6.2 更新原则

- 保持简洁，每个规范控制在 200 字以内
- 提供正例和反例
- 使用代码示例而非文字描述
- 定期审查，删除过时内容

### 6.3 版本管理

- **补丁版本（1.0.x）：** 修正错误、补充示例
- **次版本（1.x.0）：** 添加新章节、新规范
- **主版本（x.0.0）：** 重大变更、架构调整
