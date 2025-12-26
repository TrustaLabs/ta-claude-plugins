# 插件仓库结构

本仓库采用 Marketplace 结构，包含多个独立的 Claude Code 插件。

```
ta-claude-plugins/
│
├── .claude-plugin/                             # Marketplace 配置
│   └── marketplace.json                        # Marketplace 清单
│
├── plugins/                                    # 插件目录
│   │
│   ├── ta-spec/                                # 项目规范管理插件
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json                     # 插件配置
│   │   ├── commands/
│   │   │   ├── ta-init.md                      # /ta-init 命令
│   │   │   └── ta-plan.md                      # /ta-plan 命令
│   │   ├── skills/
│   │   │   ├── SKILL.md                        # Interactive Planning Skill
│   │   │   ├── examples/                       # 示例文档
│   │   │   └── references/                     # 参考文档
│   │   └── README.md
│   │
│   └── team-context/                           # 团队知识上下文插件
│       ├── .claude-plugin/
│       │   └── plugin.json                     # 插件配置
│       ├── skills/
│       │   └── SKILL.md                        # Load Context Skill
│       ├── hooks/
│       │   ├── hooks.json                      # Hook 配置
│       │   └── auto-inject-context.sh          # 自动注入脚本
│       └── README.md
│
├── docs/                                       # 共享文档目录
│   ├── team-context.md                         # 团队知识库
│   ├── team-context-guide.md                   # 团队知识系统指南
│   └── plans/                                  # 计划文档目录
│
├── README.md                                   # 仓库主文档
└── STRUCTURE.md                                # 本文件（结构说明）
```

## 插件列表

### 1. ta-spec（项目规范管理）

**功能：**
- `/ta-init` - 初始化项目文档结构（CLAUDE.md 和 docs/）
- `/ta-plan` - 交互式计划制定
- Interactive Planning Skill - 自然语言触发的计划制定

**核心文件：**
- `plugins/ta-spec/commands/ta-init.md` - 文档初始化命令
- `plugins/ta-spec/commands/ta-plan.md` - 计划制定命令
- `plugins/ta-spec/skills/SKILL.md` - Interactive Planning Skill 定义

**输出：**
- `CLAUDE.md` - 项目文档（由 ta-init 生成）
- `docs/` - 详细文档目录（由 ta-init 生成）
- `docs/plans/[功能名称]-[时间戳].md` - 实施计划（由 ta-plan 生成）

---

### 2. team-context（团队知识上下文）

**功能：**
- Load Context Skill - 加载团队编码规范、架构设计、业务知识
- 自动注入 Hook - 在会话开始时自动注入团队知识

**核心文件：**
- `plugins/team-context/skills/SKILL.md` - Load Context Skill 定义
- `plugins/team-context/hooks/hooks.json` - Hook 配置
- `plugins/team-context/hooks/auto-inject-context.sh` - 自动注入脚本
- `docs/team-context.md` - 团队知识库（核心）

**知识类型：**
- `coding-standards` - 编码规范
- `architecture` - 架构设计
- `business` - 业务知识
- `workflow` - 工作流程

---

## 使用方法

### 安装插件

```bash
# 克隆仓库
git clone https://github.com/trusta/ta-claude-plugins.git

# 链接到 Claude Code
claude-code plugins link ta-claude-plugins
```

### 使用 ta-spec 插件

```bash
# 初始化项目文档
/ta-init

# 创建实施计划
/ta-plan 添加用户认证功能
/ta-plan 实现深色模式
```

### 使用 team-context 插件

团队知识会在会话开始时自动注入（通过 Hook），无需手动操作。

如需手动加载特定类型的知识，可以使用自然语言触发 Load Context Skill。

---

## 维护指南

### 更新团队知识

```bash
# 编辑知识文件
vim docs/team-context.md

# 提交到 Git
git add docs/team-context.md
git commit -m "docs: update team context"
```

### 添加新插件

1. 在 `plugins/` 目录创建新插件目录
2. 创建 `.claude-plugin/plugin.json` 配置文件
3. 在 `.claude-plugin/marketplace.json` 中注册插件
4. 更新本文档

### 更新插件

1. 修改插件文件
2. 更新插件的 `plugin.json` 版本号
3. 提交到 Git

---

## 版本历史

- **v1.0.0** (2025-12-26)
  - ✨ 合并 ta-init 和 interactive-planning 为 ta-spec 插件
  - 🔧 重构为 Marketplace 结构
  - 📝 更新文档结构

- **v0.1.0** (2025-12-26)
  - ✨ 添加交互式计划制定功能
  - ✨ 添加团队知识上下文系统
  - 📝 完整的文档和示例
