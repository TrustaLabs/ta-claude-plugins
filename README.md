# Trusta Claude Plugins Marketplace

Trusta 团队的 Claude Code 插件集合，提供多种实用功能来增强开发体验。

## 📦 包含的插件

### 1. Interactive Planning（交互式计划制定）

通过交互式多轮对话帮助创建详细、可执行的实施计划。

**核心特性：**
- ✨ 5层次需求框架（Why/What/How/Constraints/EdgeCases）
- ✨ MoSCoW 范围确认机制，防止需求跑偏
- ✨ 4维度边界情况矩阵（数据/网络/并发/权限）
- ⚡ 灵活的3-5轮对话流程，提高信息密度
- 📝 自动生成结构化计划文档

[查看详细文档 →](./plugins/interactive-planning/README.md)

### 2. Team Context（团队知识上下文系统）

让 AI 研发助手了解和应用团队的编码规范、架构设计、业务知识和工作流程。

**核心特性：**
- ✅ 自动应用规范：AI 生成的代码自动符合团队标准
- ✅ 减少重复解释：无需每次都说明团队规范
- ✅ 新人快速上手：通过 AI 快速了解团队约定
- ✅ 知识集中管理：单一信息源，易于维护

[查看详细文档 →](./plugins/team-context/README.md)

## 🚀 快速开始

### 方式一：添加 Marketplace（推荐）

一次性添加所有插件：

```bash
claude-code marketplace add https://github.com/trusta/ta-claude-plugins.git
```

添加后，所有插件会自动安装并可用。

### 方式二：安装单个插件

```bash
# 安装交互式计划制定插件
claude-code plugin install ./plugins/interactive-planning

# 安装团队知识上下文插件
claude-code plugin install ./plugins/team-context
```


## 📖 使用指南

### Interactive Planning

使用 `/ta-plan` 命令启动计划制定流程：

```bash
/ta-plan 添加用户认证功能
```

或使用自然语言触发：
- "帮我制定实现计划"
- "创建开发计划"
- "分析需求并设计方案"

### Team Context

使用 `/ta-init` 命令加载团队知识：

```bash
# 加载所有知识
/ta-init

# 按需加载
/ta-init --type coding-standards
/ta-init --type architecture
```

插件会自动在代码生成前注入相关规范（通过 Hook 机制）。

## 🏗️ 项目结构

```
ta-claude-plugins/
├── plugins/
│   ├── interactive-planning/     # 交互式计划制定插件
│   │   ├── .claude-plugin/
│   │   ├── skills/
│   │   ├── commands/
│   │   └── README.md
│   │
│   └── team-context/             # 团队知识上下文插件
│       ├── .claude-plugin/
│       ├── skills/
│       ├── commands/
│       ├── hooks/
│       └── README.md
│
├── docs/                         # 共享文档
├── marketplace.json              # Marketplace 配置
└── README.md                     # 本文件
```

## 🤝 贡献

欢迎提出改进建议和贡献代码！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📝 许可证

MIT License - 详见各插件目录下的 LICENSE 文件

## 🔗 相关链接

- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)
- [插件开发指南](https://docs.anthropic.com/claude-code/plugins)
- [问题反馈](https://github.com/trusta/ta-claude-plugins/issues)

---

**版本：** 1.0.0
**维护者：** Trusta Team
