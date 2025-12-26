---
name: ta-init
description: 初始化项目文档结构，生成 CLAUDE.md 和 docs/ 目录
args: ""
---

# 项目文档初始化命令

此命令用于快速初始化项目的文档结构，自动生成 CLAUDE.md 和 docs/ 目录下的各类文档。

## 使用方法

```bash
/ta-init
```

## 功能特性

- **智能项目识别**：自动识别项目类型（前端/后端/Python/数据分析/Claude插件等）
- **动态文档生成**：根据项目类型推荐合适的文档清单
- **文档分层设计**：CLAUDE.md 只包含高频使用内容，详细文档放到 docs/
- **增量更新支持**：检测已存在文件，避免覆盖用户内容
- **复杂模块检测**：识别需要专门文档的复杂模块

## 执行流程

当你运行此命令时，将执行以下步骤：

### 1. 项目分析
- 扫描项目配置文件（package.json、requirements.txt 等）
- 分析项目目录结构
- 识别项目类型和技术栈
- 检测复杂模块

### 2. 文档推荐
根据项目类型推荐文档清单：

**前端项目**：ARCHITECTURE.md, THEME.md, COMPONENTS.md, TESTING.md, API.md

**Node.js 后端**：ARCHITECTURE.md, API.md, DATABASE.md, TESTING.md, DEPLOYMENT.md

**Python 后端**：ARCHITECTURE.md, API.md, DATABASE.md, TESTING.md, DEPLOYMENT.md

**数据分析**：DATA_SOURCES.md, ANALYSIS_WORKFLOW.md, MODELS.md, TESTING.md

**Claude 插件**：PLUGIN_STRUCTURE.md, COMMANDS.md, SKILLS.md, HOOKS.md, TESTING.md

### 3. 交互确认
- 展示识别结果
- 询问用户选择需要的文档
- 确认复杂模块是否需要专门文档

### 4. 文档生成
- 生成精简的 CLAUDE.md（<500行）
- 生成选定的 docs/ 文档
- 检测文件冲突，询问处理方式

### 5. 后续指导
- 显示生成的文档清单
- 提供后续建议

## 生成的文档结构

```
项目根目录/
├── CLAUDE.md              # 精简版项目文档
└── docs/
    ├── ARCHITECTURE.md    # 架构设计（按需）
    ├── TESTING.md         # 测试规范（按需）
    ├── API.md             # API 文档（按需）
    ├── CONTRIBUTING.md    # 贡献指南（按需）
    └── ...                # 其他文档（按需）
```

## CLAUDE.md 内容

生成的 CLAUDE.md 包含：
- 项目概述（1-2句话）
- 技术栈
- 项目结构（简略）
- 常用命令
- 编码规范（核心规则）
- 📚 详细文档索引（Reference 机制）

## Reference 机制

CLAUDE.md 中会包含详细文档索引，引导 AI 在需要时读取对应文档：

```markdown
## 📚 详细文档索引

当需要了解以下内容时，请阅读对应文档：

- **架构设计和技术选型** → 请阅读 `docs/ARCHITECTURE.md`
- **测试策略和测试用例编写** → 请阅读 `docs/TESTING.md`
- **API 接口定义和使用** → 请阅读 `docs/API.md`

⚠️ **重要**：在开始实现功能前，如果涉及以上领域，请先使用 Read 工具阅读相关文档。
```

## 增量更新

如果检测到文件已存在，会询问处理方式：
- **覆盖**：用新内容替换现有文件
- **跳过**：保留现有文件，不生成新文件
- **合并**：尝试合并内容（仅限部分文件）

## 注意事项

- 生成的文档是模板，需要根据项目实际情况补充完善
- CLAUDE.md 应保持精简，避免占用过多上下文
- 详细内容应放到 docs/ 目录，通过 Reference 机制引用
- 建议定期使用 doc-sync skill 检查文档是否需要更新

## 相关资源

- 详细实施计划：`docs/plans/ta-init-command-20251226.md`
- 文档更新检测：使用 doc-sync skill（开发中）

---

## 执行指令

**重要：** 当此命令被调用时，执行以下步骤：

### 步骤 1：项目分析

使用以下工具分析项目：

1. **检测项目类型**
   - 使用 Read 工具读取 package.json（如果存在）
   - 使用 Read 工具读取 requirements.txt（如果存在）
   - 使用 Read 工具读取 .claude-plugin/plugin.json（如果存在）
   - 使用 Glob 工具扫描项目目录结构

2. **识别项目特征**
   - 提取项目名称、描述、依赖
   - 推断项目类型（前端/后端/Python/数据分析/Claude插件/通用）
   - 推断框架（React/Vue/Express/FastAPI/Django等）

3. **分析复杂模块**
   - 使用 Glob 扫描关键目录（src/、app/、notebooks/ 等）
   - 识别可能需要专门文档的模块（auth/、theme/、models/ 等）

### 步骤 2：推荐文档清单

根据识别的项目类型，推荐文档清单：

```
前端项目 → ARCHITECTURE.md, THEME.md, COMPONENTS.md, TESTING.md, API.md
Node.js后端 → ARCHITECTURE.md, API.md, DATABASE.md, TESTING.md, DEPLOYMENT.md
Python后端 → ARCHITECTURE.md, API.md, DATABASE.md, TESTING.md, DEPLOYMENT.md
数据分析 → DATA_SOURCES.md, ANALYSIS_WORKFLOW.md, MODELS.md, TESTING.md
Claude插件 → PLUGIN_STRUCTURE.md, COMMANDS.md, SKILLS.md, HOOKS.md, TESTING.md
通用项目 → ARCHITECTURE.md, TESTING.md, CONTRIBUTING.md
```

### 步骤 3：交互确认

使用 AskUserQuestion 工具询问用户：

1. **确认项目类型**
   - 展示识别结果
   - 询问是否正确，如不正确让用户选择

2. **选择文档**
   - 展示推荐的文档清单
   - 询问用户选择需要生成的文档（多选）

3. **复杂模块文档**
   - 如果检测到复杂模块，询问是否需要专门文档

### 步骤 4：生成文档

1. **检测文件冲突**
   - 使用 Read 工具检测 CLAUDE.md 是否存在
   - 使用 Glob 工具检测 docs/ 目录是否存在
   - 如果存在，使用 AskUserQuestion 询问处理方式

2. **生成 CLAUDE.md**
   - 使用 Write 工具生成 CLAUDE.md
   - 包含：项目概述、技术栈、项目结构、常用命令、编码规范、Reference索引
   - 控制长度：不超过 500 行

3. **生成 docs/ 文档**
   - 使用 Bash 工具创建 docs/ 目录（如果不存在）
   - 根据用户选择，使用 Write 工具生成各类文档
   - 使用模板填充基础内容

### 步骤 5：后续指导

输出生成清单和后续建议：

```
✅ 文档初始化完成！

生成的文档：
- CLAUDE.md
- docs/ARCHITECTURE.md
- docs/TESTING.md
- docs/API.md

后续建议：
1. 根据项目实际情况补充完善文档内容
2. 确保 CLAUDE.md 保持精简（<500行）
3. 详细内容放到 docs/ 目录
4. 定期检查文档是否需要更新
```

## 实现注意事项

- 使用 Read 工具读取文件前，先用 Glob 检查文件是否存在
- 生成文档时使用模板，确保格式统一
- Reference 索引应根据实际生成的文档动态调整
- 复杂模块检测可以基于目录名称和文件数量进行简单判断
- 所有交互都应使用 AskUserQuestion 工具，确保用户参与决策