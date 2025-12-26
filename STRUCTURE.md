# 插件目录结构

```
ta-claude-plugins/
│
├── .claude-plugin/                             # 插件配置
│   └── plugin.json                             # 插件清单
│
├── skills/                                     # Skills 目录
│   ├── interactive-planning/                   # 交互式计划制定 Skill
│   │   ├── SKILL.md                            # Skill 定义
│   │   ├── examples/
│   │   │   └── plan-template.md                # 计划模板
│   │   └── references/
│   │       └── planning-best-practices.md      # 计划最佳实践
│   │
│   └── load-context/                           # 加载团队知识 Skill
│       ├── skill.md                            # Skill 定义
│       └── examples/
│           └── usage.md                        # 使用示例
│
├── commands/                                   # Commands 目录
│   └── ta-plan.md                              # /ta-plan 命令
│
├── hooks/                                      # Hooks 目录
│   ├── hooks.json                              # Hook 配置
│   └── auto-inject-context.sh                 # 自动注入脚本
│
├── docs/                                       # 文档目录
│   ├── team-context.md                         # 团队知识库（核心文件）
│   ├── quick-start.md                          # 快速开始指南
│   ├── team-context-guide.md                   # 团队知识上下文详细指南
│   └── plans/                                  # 计划文档目录
│       └── team-context-system-20251226.md     # 团队知识系统实施计划
│
├── README.md                                   # 插件主文档
├── QUICKSTART.md                               # 快速开始
└── STRUCTURE.md                                # 本文件（目录结构说明）
```

## 核心组件

### 1. 交互式计划制定 (Interactive Planning)

**入口：**
- Command: `/ta-plan [功能描述]`
- Skill: 自然语言触发（"制定计划"、"创建计划"等）

**文件：**
- `skills/interactive-planning/SKILL.md` - Skill 定义
- `skills/interactive-planning/references/planning-best-practices.md` - 方法论
- `skills/interactive-planning/examples/plan-template.md` - 模板
- `commands/ta-plan.md` - 命令定义

**输出：**
- `docs/plans/[功能名称]-[时间戳].md` - 生成的计划文档

---

### 2. 团队知识上下文系统 (Team Context)

**入口：**
- Skill: `/load-context [--type <类型>]`

**文件：**
- `docs/team-context.md` - 团队知识库（核心）
- `skills/load-context/skill.md` - Skill 定义
- `skills/load-context/examples/usage.md` - 使用示例
- `docs/quick-start.md` - 快速开始指南
- `docs/team-context-guide.md` - 详细使用指南
- `docs/plans/team-context-system-20251226.md` - 实施计划

**知识类型：**
- `coding-standards` - 编码规范
- `architecture` - 架构设计
- `business` - 业务知识
- `workflow` - 工作流程

---

## 使用方法

### 交互式计划制定

```bash
# 使用命令
/ta-plan 添加用户认证功能

# 或自然语言
"帮我制定一个实施计划"
```

### 团队知识上下文

```bash
# 加载所有知识
/load-context

# 按类型加载
/load-context --type coding-standards
/load-context --type architecture
/load-context --type business
/load-context --type workflow

# 组合加载
/load-context --type coding-standards,architecture
```

---

## 文件说明

### 配置文件

- **`.claude-plugin/plugin.json`** - 插件清单，定义插件名称、版本、skills 等
- **`.claude/settings.local.json`** - 本地设置（不提交到 Git）

### 知识文件

- **`docs/team-context.md（会提交到 Git）`** - 团队知识库，包含编码规范、架构设计、业务知识、工作流程

### Skills

- **`skills/interactive-planning/SKILL.md`** - 交互式计划制定 Skill
- **`skills/load-context/skill.md`** - 加载团队知识 Skill

### Commands

- **`commands/ta-plan.md`** - `/ta-plan` 命令定义

### 文档

- **`README.md`** - 插件主文档
- **`QUICKSTART.md`** - 快速开始
- **`docs/quick-start.md`** - 团队知识系统快速开始
- **`docs/team-context-guide.md`** - 团队知识系统详细指南
- **`docs/plans/`** - 生成的计划文档目录

---

## 维护指南

### 更新团队知识

```bash
# 1. 编辑知识文件
vim docs/team-context.md

# 2. 更新 last_updated 字段
# 3. 提交到 Git
git add docs/team-context.md
git commit -m "docs: update team context"
```

### 添加新 Skill

1. 在 `skills/` 目录创建新的 skill 目录
2. 创建 `SKILL.md` 或 `skill.md` 文件
3. 在 `.claude-plugin/plugin.json` 中添加 skill 路径
4. 更新 `README.md` 文档

### 添加新 Command

1. 在 `commands/` 目录创建新的命令文件
2. 使用 YAML frontmatter 定义命令
3. 更新 `README.md` 文档

---

## 版本历史

- **v0.1.0** (2025-12-26)
  - ✨ 添加交互式计划制定功能
  - ✨ 添加团队知识上下文系统
  - 📝 完整的文档和示例
