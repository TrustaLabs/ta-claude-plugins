# 示例：复杂重构项目的交互式计划

## 场景
用户需要将一个使用 Redux 的 React 应用迁移到使用 Zustand 进行状态管理。

## 交互流程

### 用户请求
```
用户：我想把项目的状态管理从 Redux 迁移到 Zustand，代码库比较大，有20多个组件在使用 Redux。
```

### 第1轮：需求全貌挖掘

**AI 提问（使用 AskUserQuestion 一次性提出多个问题）：**

**问题1：迁移动机与目标**
- 为什么要迁移？（Redux 太复杂？性能问题？团队偏好？）
- 成功标准是什么？（所有功能正常？性能提升？代码量减少？）
- 是否有时间限制或里程碑要求？

**问题2：当前状态分析**
- Redux 的使用情况：有多少个 reducer？使用了哪些中间件（redux-thunk, redux-saga）？
- 是否使用了 Redux Toolkit？
- 异步逻辑如何处理？
- 是否有复杂的状态派生逻辑（selectors）？

**问题3：迁移策略**
- 是否可以渐进式迁移（Redux 和 Zustand 共存一段时间）？
- 是否需要保持相同的 API 接口（减少组件改动）？
- 测试覆盖率如何？是否有足够的测试保障？

**用户回答：**
```
- 动机：Redux 样板代码太多，团队觉得维护成本高
- 成功标准：所有功能正常，代码量减少30%以上，性能不下降
- 时间：希望2周内完成
- Redux 使用：8个 reducer，使用 redux-thunk 处理异步，没用 Redux Toolkit
- 异步逻辑：主要是 API 调用，使用 thunk
- Selectors：有一些复杂的派生状态
- 迁移策略：可以渐进式迁移，但希望尽快完成
- 测试：有基本的单元测试，覆盖率约60%
```

**AI 输出 MoSCoW 范围矩阵：**

```markdown
**Must Have（必须实现）**
- [ ] 迁移所有8个 reducer 到 Zustand stores
- [ ] 迁移所有异步逻辑（thunks）
- [ ] 更新所有使用 Redux 的组件（20+个）
- [ ] 保持所有现有功能正常工作
- [ ] 更新相关测试

**Should Have（应该实现）**
- [ ] 性能对比测试（迁移前后）
- [ ] 迁移文档（供团队参考）
- [ ] 代码审查检查清单

**Could Have（可以实现）**
- [ ] 创建自定义 hooks 简化常见模式
- [ ] 添加 DevTools 集成

**Won't Have（不实现）**
- [ ] 重写业务逻辑（仅迁移状态管理）
- [ ] 添加新功能
```

### 第2轮：技术方案评估

**AI 输出技术方案对比：**

```markdown
**方案A：一次性完全迁移**
- 优点：干净利落，无技术债务
- 缺点：风险高，回滚困难，开发期间功能冻结
- 时间：约10天

**方案B：渐进式迁移（推荐）**
- 优点：风险可控，可随时回滚，不影响新功能开发
- 缺点：短期内两套状态管理共存，代码稍显冗余
- 时间：约12天

**推荐方案B的理由：**
1. 降低风险：每次迁移一个模块，出问题容易定位
2. 可持续交付：不阻塞其他开发工作
3. 易于回滚：如果某个模块有问题，只需回滚该模块
```

### 第3轮：实施路径规划

**AI 输出详细实施步骤：**

```markdown
### 阶段1：准备工作（1天）
- [ ] 安装 Zustand 依赖（文件：package.json）
- [ ] 创建 Zustand store 目录结构（目录：src/stores/）
- [ ] 设置 Zustand DevTools（文件：src/stores/middleware.ts）
- [ ] 创建迁移指南文档（文件：docs/zustand-migration-guide.md）

### 阶段2：迁移简单模块（2天）
优先迁移依赖少、逻辑简单的模块，积累经验

- [ ] 迁移 UI state（loading, modals）（文件：src/stores/uiStore.ts）
  - 原文件：src/redux/reducers/uiReducer.ts
  - 影响组件：LoadingSpinner.tsx, Modal.tsx（2个）
- [ ] 迁移 theme state（文件：src/stores/themeStore.ts）
  - 原文件：src/redux/reducers/themeReducer.ts
  - 影响组件：ThemeProvider.tsx, ThemeToggle.tsx（2个）
- [ ] 更新相关组件和测试

### 阶段3：迁移核心业务模块（4天）
- [ ] 迁移 user state（文件：src/stores/userStore.ts）
  - 原文件：src/redux/reducers/userReducer.ts
  - 包含异步逻辑：login, logout, fetchProfile
  - 影响组件：Header.tsx, Profile.tsx, Settings.tsx（5个）
- [ ] 迁移 products state（文件：src/stores/productsStore.ts）
  - 原文件：src/redux/reducers/productsReducer.ts
  - 包含异步逻辑：fetchProducts, createProduct, updateProduct
  - 影响组件：ProductList.tsx, ProductDetail.tsx, ProductForm.tsx（6个）
- [ ] 迁移 cart state（文件：src/stores/cartStore.ts）
  - 原文件：src/redux/reducers/cartReducer.ts
  - 包含复杂派生逻辑：总价计算、折扣计算
  - 影响组件：Cart.tsx, CartItem.tsx, Checkout.tsx（4个）

### 阶段4：迁移剩余模块（2天）
- [ ] 迁移 notifications state（文件：src/stores/notificationsStore.ts）
- [ ] 迁移 settings state（文件：src/stores/settingsStore.ts）
- [ ] 迁移 analytics state（文件：src/stores/analyticsStore.ts）
- [ ] 影响组件：约5个

### 阶段5：清理和优化（2天）
- [ ] 删除所有 Redux 相关代码
  - 删除文件：src/redux/ 目录
  - 删除依赖：redux, react-redux, redux-thunk
- [ ] 删除 Redux Provider（文件：src/App.tsx）
- [ ] 更新所有测试
- [ ] 性能对比测试
- [ ] 代码审查

### 阶段6：文档和培训（1天）
- [ ] 完善迁移文档
- [ ] 创建 Zustand 使用指南
- [ ] 团队分享会
```

### 第4轮：风险和边界情况

**AI 输出边界情况矩阵：**

| 维度 | 场景 | 触发条件 | 处理方案 | 优先级 |
|------|------|---------|---------|--------|
| **兼容性** | Redux和Zustand共存 | 渐进式迁移期间 | 确保两者不冲突，独立管理状态 | 高 |
| **性能** | 重渲染增加 | Zustand使用不当 | 使用 shallow 比较，拆分 store | 高 |
| **数据** | 状态迁移丢失 | 用户刷新页面 | 保持 localStorage 持久化逻辑 | 高 |
| **测试** | 测试失败 | Mock方式改变 | 更新测试工具函数，提供新的 mock helpers | 中 |
| **回滚** | 迁移失败需回滚 | 严重bug | 保留 Redux 代码直到全部迁移完成 | 高 |
| **团队** | 团队不熟悉Zustand | 新的API | 提供培训和文档，code review | 中 |

**风险评估：**

| 风险 | 影响 | 概率 | 缓解措施 |
|------|------|------|----------|
| 迁移引入新bug | 高 | 中 | 充分测试，渐进式迁移，保留回滚能力 |
| 性能下降 | 中 | 低 | 性能基准测试，优化 selector 使用 |
| 时间超期 | 中 | 中 | 预留缓冲时间，优先核心功能 |
| 团队学习曲线 | 低 | 高 | 提前培训，提供文档和示例 |

### 第5轮：测试策略与最终审查

**AI 输出测试策略：**

```markdown
**测试策略**

1. **单元测试**
   - 每个 Zustand store 的独立测试
   - 覆盖率目标：>80%
   - 重点：状态更新逻辑、异步操作、派生状态

2. **集成测试**
   - 组件与 store 的集成测试
   - 使用 React Testing Library
   - 重点：用户交互流程、状态同步

3. **E2E 测试**
   - 关键业务流程：登录、购物、结账
   - 使用现有的 E2E 测试套件
   - 确保迁移后功能完全一致

4. **性能测试**
   - 使用 React DevTools Profiler
   - 对比迁移前后的渲染次数和时间
   - 重点：列表渲染、频繁更新的组件

**最终完整性检查**
- [x] 所有8个 reducer 都有对应的迁移计划
- [x] 所有20+个组件都已识别和规划
- [x] 渐进式迁移策略降低风险
- [x] 每个阶段都有明确的交付物
- [x] 测试策略覆盖所有层次
- [x] 有明确的回滚方案
- [x] 时间估算合理（12天）
```

## 最终计划文档

保存到：`docs/plans/redux-to-zustand-migration-20250126.md`

## 关键要点

1. **5轮对话完成** - 复杂项目需要更多轮次深入讨论
2. **技术方案对比** - 评估多个方案，选择最优解
3. **渐进式迁移** - 降低风险，保持可持续交付
4. **详细的任务分解** - 每个任务都有具体的文件路径和影响范围
5. **全面的风险评估** - 识别潜在问题并提供缓解措施
6. **多层次测试策略** - 确保迁移质量
