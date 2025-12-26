# Trusta Claude Plugins Marketplace

Trusta 团队的 Claude Code 插件集合，提供项目规范管理和团队知识上下文功能。

## 项目概述

这是一个 Claude Code 插件 Marketplace，包含两个核心插件：
- **trusta-spec**：项目规范管理插件，提供文档初始化和交互式计划制定功能
- **trusta-team-context**：团队知识上下文插件，让 AI 自动应用团队编码规范和业务知识

## 技术栈

- **平台**：Claude Code Plugin System
- **语言**：Markdown (插件配置和文档)
- **版本控制**：Git
- **插件机制**：Skills, Commands, Hooks

## 项目结构

```
ta-claude-plugins/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace 配置
├── plugins/
│   ├── ta-spec/                  # 项目规范管理插件
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json       # 插件配置
│   │   ├── commands/             # 斜杠命令
│   │   │   ├── ta-init.md        # 文档初始化命令
│   │   │   └── ta-plan.md        # 计划制定命令
│   │   ├── skills/               # 技能定义
│   │   │   └── skills/
│   │   │       ├── SKILL.md      # 主技能文件
│   │   │       ├── examples/     # 示例
│   │   │       └── references/   # 参考资料
│   │   └── README.md
│   │
│   └── team-context/             # 团队知识上下文插件
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── hooks/                # 钩子定义
│       │   └── hooks.json
│       ├── skills/               # 技能定义
│       │   ├── skill.md
│       │   └── examples/
│       └── README.md
│
├── docs/                         # 共享文档
│   ├── plans/                    # 实施计划
│   ├── team-context.md           # 团队上下文说明
│   ├── team-context-guide.md     # 使用指南
│   ├── PLUGIN_DEVELOPMENT.md     # 插件开发指南
│   └── CONTRIBUTING.md           # 贡献指南
│
├── CLAUDE.md                     # 本文件
├── README.md                     # 项目说明
└── STRUCTURE.md                  # 结构说明
```

## 常用命令

### 插件管理

```bash
# 添加 Marketplace（推荐）
claude plugin marketplace add https://github.com/trusta/ta-claude-plugins.git

# 安装单个插件
claude plugin install ./plugins/ta-spec
claude plugin install ./plugins/team-context

# 查看已安装插件
claude plugin list

# 更新插件
claude plugin marketplace update trusta-claude-plugins-marketplace
```

### 使用插件命令

```bash
# 初始化项目文档结构
/ta-init

# 创建详细实施计划
/ta-plan <任务描述>
```

### Git 操作

```bash
# 提交更改
git add .
git commit -m "描述"
git push

# 创建新分支
git checkout -b feature/new-feature

# 查看状态
git status
```

## 编码规范

### 文档规范

1. **Markdown 格式**
   - 使用中文书写文档和注释
   - 标题层级清晰，使用 `#` 到 `####`
   - 代码块使用三个反引号，指定语言类型

2. **插件配置**
   - `plugin.json` 必须包含 name, version, description
   - 使用语义化版本号（Semantic Versioning）
   - keywords 应准确描述插件功能

3. **命令和技能**
   - 命令文件使用 kebab-case 命名（如 `ta-init.md`）
   - 技能文件使用 SKILL.md 或 skill.md
   - 包含清晰的使用说明和示例

### Git 规范

1. **提交信息格式**
   ```
   <type>(<scope>): <subject>

   类型：feat, fix, docs, style, refactor, test, chore
   范围：插件名或功能模块
   主题：简短描述（中文）
   ```

2. **分支管理**
   - `main`：主分支，保持稳定
   - `feature/*`：新功能分支
   - `fix/*`：修复分支

3. **文件操作**
   - 使用 `git mv` 而不是 `mv` 来移动文件
   - 确保 git 能正确追踪文件移动和重命名

### 插件开发规范

1. **目录结构**
   - 每个插件独立目录，包含 `.claude-plugin/plugin.json`
   - 按功能组织：commands/, skills/, hooks/
   - 提供完整的 README.md

2. **命令设计**
   - 命令名使用 `/` 前缀
   - 提供清晰的参数说明
   - 包含执行指令和实现细节

3. **技能设计**
   - 使用渐进式披露（Progressive Disclosure）
   - 提供示例和参考资料
   - 明确触发条件

4. **钩子设计**
   - 使用 JSON 配置钩子
   - 明确钩子触发时机
   - 避免过度干预用户操作

## 📚 详细文档索引

当需要了解以下内容时，请阅读对应文档：

- **插件开发指南和最佳实践** → 请阅读 `docs/PLUGIN_DEVELOPMENT.md`
- **贡献代码和提交 PR 流程** → 请阅读 `docs/CONTRIBUTING.md`
- **团队知识上下文系统** → 请阅读 `docs/team-context-guide.md`
- **项目结构详细说明** → 请阅读 `STRUCTURE.md`

⚠️ **重要**：在开始实现功能前，如果涉及以上领域，请先使用 Read 工具阅读相关文档。

## 插件功能说明

### trusta-spec（项目规范管理）

**命令：**
- `/ta-init`：初始化项目文档结构，生成 CLAUDE.md 和 docs/ 目录
- `/ta-plan`：启动交互式计划制定流程

**技能：**
- 自动触发计划制定流程
- 使用 5 层次需求框架深度挖掘需求
- MoSCoW 矩阵防止需求跑偏
- 4 维度边界情况矩阵

### trusta-team-context（团队知识上下文）

**功能：**
- 自动加载团队编码规范
- 在代码生成前注入相关知识
- 支持按类型过滤加载（coding-standards, architecture, business, workflow）

**钩子：**
- PreToolUse：在工具调用前注入团队知识

## 开发工作流

1. **添加新功能**
   - 创建 feature 分支
   - 实现功能并测试
   - 更新相关文档
   - 提交 PR

2. **修复问题**
   - 创建 fix 分支
   - 定位并修复问题
   - 添加测试用例（如适用）
   - 提交 PR

3. **更新文档**
   - 直接在 main 分支或创建 docs 分支
   - 更新相关文档
   - 提交更改

## 注意事项

1. **文档维护**
   - CLAUDE.md 保持精简（<500行）
   - 详细内容放到 docs/ 目录
   - 使用 Reference 机制引导 AI 读取详细文档

2. **插件开发**
   - 遵循 Claude Code 插件开发规范
   - 提供清晰的使用说明和示例
   - 测试插件在不同场景下的表现

3. **版本管理**
   - 使用语义化版本号
   - 更新版本号时同步更新 plugin.json 和 marketplace.json
   - 在 README.md 中记录版本变更

## 相关资源

- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)
- [插件开发指南](https://docs.anthropic.com/claude-code/plugins)
- [问题反馈](https://github.com/trusta/ta-claude-plugins/issues)

---

**版本：** 1.0.0
**维护者：** Trusta Team
**许可证：** MIT