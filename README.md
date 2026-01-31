# Bjarne

自主 AI 开发循环。给它一个想法，回来时项目就完成了。

**简而言之：** 在 markdown 文件中写下你想要的内容 → 运行 `bjarne init idea.md` → 运行 `bjarne` → 等待 → 完成。

## 快速开始

```bash
# 安装
sudo curl -o /usr/local/bin/bjarne https://raw.githubusercontent.com/lichengfxf/AutoCode/refs/heads/master/bjarne && sudo chmod +x /usr/local/bin/bjarne

# 创建想法文件
echo "一个将 markdown 转换为 PDF 的 CLI 工具" > idea.md

# 初始化（创建 CONTEXT.md 和 TASKS.md）
bjarne init idea.md

# 运行循环
bjarne
```

就是这样。Bjarne 会循环处理任务，直到你的项目构建完成。

## 核心概念：以结果为导向的任务

Bjarne 不是一个愚蠢的"一直运行直到完成"的循环。它使用**可验证的结果**。

`TASKS.md` 中的每个任务都遵循以下格式：

```markdown
- [ ] 行动 → 结果
```

例如：
```markdown
- [ ] 在导航栏添加登录按钮 → header 中存在 href="/login" 的按钮
- [ ] 创建 /api/users 端点 → GET /api/users 返回 200 和 JSON 数组
- [ ] 添加邮箱验证 → 无效邮箱显示错误消息
```

结果必须是**机器可验证的**。Bjarne 的 REVIEW 阶段会实际检查结果是否达成（搜索元素、curl 端点、验证文件存在）然后继续。只有在结果得到确认后，任务才算完成。

这就是 Bjarne 与简单循环的区别：

| 问题 | 简单循环 | Bjarne |
|------|---------|--------|
| 安全漏洞 | 直到生产环境才检测到 | 在 REVIEW 中捕获 |
| DRY 违规 | 复制粘贴蔓延 | 标记并重构 |
| 日益庞大的单体 | 文件不受控制地膨胀 | 架构被审查 |
| 测试失败 | 被忽略或禁用 | 必须通过才能继续 |
| 死代码 | 静默积累 | 在 FIX 中清理 |

## 工作原理

```
idea.md → INIT → [PLAN → EXECUTE → REVIEW → FIX] × N → 完成
                              ↑
                    notes.md → REFRESH (添加更多任务)

        "修复 X" → TASK → [PLAN → EXECUTE → REVIEW → FIX] → 分支 + PR
                         (隔离状态，自动清理)
```

每次迭代：
1. **规划** - 选择第一个未选中的任务（或使用 `-b` 时的相关任务批次），提取预期结果，编写包含验证步骤的计划
2. **执行** - 实现计划，标记任务为完成
3. **评审** - 验证结果已达成，然后检查代码质量
4. **修复** - 首先修复失败的结果，然后处理其他问题

## Bjarne 创建的文件

当你运行 `bjarne init` 时，它会创建这些驱动整个流程的文件：

| 文件 | 用途 |
|------|------|
| `CONTEXT.md` | 静态项目参考 - 技术栈、架构、约束 |
| `TASKS.md` | 带复选框的任务列表 - 这是"大脑" |
| `specs/` | 复杂功能的详细规范 |
| `.task` | 当前任务状态（临时，每次迭代） |

`TASKS.md` 是真实来源。Bjarne 读取它，选择下一个未选中的任务，处理它，并标记为完成。

## 使用 Claude 管理 Bjarne

这里有一些强大的功能：**你可以使用 Claude Code 来设置和管理 Bjarne 项目**。

> **提示：** 在让 Claude 帮助 Bjarne 之前，先让它阅读这个 README：
> ```bash
> claude "阅读 https://github.com/lichengfxf/AutoCode/blob/master/README.md 然后帮我为 [你的想法] 设置一个 Bjarne 项目"
> ```

### 让 Claude 编写你的想法文件

不确定如何描述你想要什么？让 Claude 面试你：

```bash
claude "我想构建 [简短描述]。问我问题以了解我的需求，然后编写一个详细的 idea.md 文件，我可以与 Bjarne 一起使用。"
```

Claude 会询问技术偏好、功能、约束，并生成一个结构良好的想法文件。

### 让 Claude 直接创建 CONTEXT.md 和 TASKS.md

你不必使用 `bjarne init`。你可以让 Claude 手动创建文件：

```bash
claude "查看这个代码库并创建一个 CONTEXT.md 和 TASKS.md 来添加 [功能]。使用以结果为导向的格式：'- [ ] 行动 → 可验证的结果'"
```

这在以下情况下很有用：
- 你想要更多对任务分解的控制
- 你正在向现有项目添加功能
- 你想在 Bjarne 运行之前查看/编辑任务

### 让 Claude 在项目中完善任务

Bjarne 正在运行但任务不太正确？停止它并让 Claude 帮助：

```bash
claude "查看 TASKS.md。这些任务不够具体。用更清晰、更可验证的结果重写它们。"
```

### 让 Claude 审查进度

在 Bjarne 完成后（或者如果你停止它）：

```bash
claude "审查 Bjarne 构建的内容。检查 TASKS.md 中的已完成项目，并验证结果是否真正实现。列出需要修复的任何内容。"
```

### 元工作流

最强大的模式：

1. **Claude** 帮助你编写 `idea.md`
2. **Bjarne** 运行 `init` 并创建任务
3. **Claude** 审查和完善 `TASKS.md`（如果需要）
4. **Bjarne** 执行循环
5. **Claude** 审查输出，编写 `notes.md`
6. **Bjarne** 运行 `refresh notes.md` 并继续
7. 重复直到满意

你将 Claude 作为"项目经理"，Bjarne 作为"工作者"。

## 编写好的想法文件

### 简单的想法

对于简单的项目，一行就够了：

```markdown
一个将 markdown 文件转换为 PDF 的 CLI 工具
```

Bjarne 会为技术栈、测试等填充合理的默认值。

### 详细的想��

对于特定要求，要明确：

```markdown
# 发票生成器

一个供自由职业者创建和管理发票的 Web 应用。

## 技术栈
- Next.js 14 with App Router
- SQLite 数据库，使用 Drizzle ORM
- Tailwind CSS

## 功能
- 仪表板显示所有发票及其状态（草稿/已发送/已支付）
- 创建发票表单：客户名称、行项目、税率
- 使用专业模板生成 PDF

## 约束
- 无身份验证（单用户）
- 所有金额以美元为单位
```

### 提示

- **简单的想法**会得到合理的默认值
- **详细的想法**会严格按照 written 尊重
- 如果你在意，就添加约束（例如，"使用 Python"，"无依赖"）
- Bjarne 无头运行 - 它无法提问，所以提前明确
- 你提供的细节越多，结果越接近你的愿景

## 命令参考

| 命令 | 作用 |
|------|------|
| `bjarne init idea.md` | 从想法文件创建项目 |
| `bjarne init --safe idea.md` | 相同，但启用 Docker 沙箱 |
| `bjarne` | 运行开发循环 |
| `bjarne 50` | 运行 50 次迭代（默认：25） |
| `bjarne --batch` | 启用批量模式（最多 5 个相关任务） |
| `bjarne --batch 50` | 批量模式，50 次迭代 |
| `bjarne --batch=3` | 批量模式，自定义大小（最多 3 个任务） |
| `bjarne --batch=3 50` | 批量最多 3 个任务，50 次迭代 |
| `bjarne refresh notes.md` | 从反馈笔记添加任务 |
| `bjarne task "描述"` | 运行隔离的单任务修复 |
| `bjarne --rebuild` | 重新构建 Docker 镜像（安全模式） |
| `bjarne --update` | 立即检查更新 |
| `bjarne --disable-auto-update` | 禁用自动更新 |
| `bjarne --enable-auto-update` | 重新启用自动更新 |

## 工作流详情

### 初始化

```bash
bjarne init idea.md
```

创建 `CONTEXT.md`、`TASKS.md` 和可选的 `specs/`。

**适用于现有项目！** 如果你在有现有代码的文件夹中运行 `init`，Bjarne 会检测你的代码库，了解已构建的内容，并创建在现有代码基础上构建的任务。

### 运行

```bash
bjarne          # 默认：最多 25 次迭代
bjarne 50       # 自定义：最多 50 次迭代
```

### 批量模式

默认情况下，Bjarne 每个 PLAN → EXECUTE → REVIEW → FIX 循环处理一个任务。批量模式将相关任务分组在一起：

```bash
bjarne --batch        # 批量模式，最多 5 个相关任务
bjarne --batch 50     # 批量模式，50 次迭代
bjarne --batch=3      # 批量模式，最多 3 个相关任务
bjarne --batch=3 50   # 最多 3 个任务，50 次迭代
bjarne -b3 50         # 简写：最多 3 个任务，50 次迭代
bjarne -b             # 简写：批量模式，默认大小（5）
```

**工作原理：** 不是只选择第一个未选中的任务，Bjarne 扫描所有待处理任务并将自然属于在一起的任务分组 - 同一个文件、同一个功能、逻辑依赖。它可能批处理 1 个任务（如果是独立的）或最多 N 个任务（如果紧密耦合）。

**权衡：**

| | 单任务（默认） | 批量模式 |
|---|---|---|
| 上下文使用 | 更高（每个任务完整循环） | 更低（多个任务一个循环） |
| 速度 | 更慢 | 更快 |
| 精度 | 更高（专注注意力） | 可能更低（注意力分散） |
| 最适合 | 复杂任务，精度工作 | 相关任务，更快迭代 |

**何时使用批量模式：**
- 许多小的相关任务（例如，"添加字段 X"，"添加字段 Y"，"添加字段 Z"）
- 在 TASKS.md 中按阶段分组的任务
- 你想要更快迭代并接受轻微的精度权衡

**何时坚持单任务：**
- 复杂的架构任务
- 需要仔细、专注实现的任务
- 当精度比速度更重要时

### 刷新

在测试你的项目后，发现了 bug 或想要新功能？编写自由格式的笔记：

```markdown
# notes.md
登录按钮在移动设备上不起作用
添加暗色模式切换
最好有一个加载旋转器
```

然后：
```bash
bjarne refresh notes.md
bjarne  # 再次运行
```

Bjarne 将你的笔记转换为正确格式的任务并继续。

### 任务模式（隔离修复）

需要快速修复而不接触主项目状态？

```bash
bjarne task "修复登录按钮无响应"
```

任务模式：
- 在 `.bjarne/tasks/<task-id>/` 中创建隔离状态
- 运行完整的 PLAN → EXECUTE → REVIEW → FIX 循环
- 创建 git 分支和 PR（如果 git/gh 可用）
- 自动清理

选项：
```bash
bjarne task "描述"                  # 文本描述
bjarne task bugfix.md              # 从文件读取
bjarne task --safe "描述"          # Docker 沙箱
bjarne task --no-pr "..."          # 跳过 PR 创建
bjarne task -n 10 "..."            # 限制为 10 次迭代
bjarne task --no-worktree "..."    # 在当前分支工作（影响其他会话）
```

**何时使用哪个：**

| 场景 | 使用 |
|------|------|
| 构建新项目 | `bjarne init` + `bjarne` |
| 向现有项目添加功能 | `bjarne refresh` + `bjarne` |
| 快速隔离修复 | `bjarne task` |
| 并行多个修复 | 在不同终端中运行多个 `bjarne task` |

## 安全模式

无人值守运行 Bjarne？使用安全模式：

```bash
bjarne init --safe idea.md   # 创建 Docker 配置
bjarne                        # 自动在容器中运行
```

你只需要在 `init` 时使用 `--safe`。一旦 `.bjarne/Dockerfile` 存在，所有后续的 `bjarne` 运行都会自动检测它并使用 Docker。

安全模式：
- 在 Docker 容器内运行 Claude
- 容器只能看到你的项目目录
- 系统的其余部分完全受保护
- 你的 Claude 凭证以只读方式挂载

自动检测你的技术栈（Node.js、Python、Rust、Go、PHP）并使用适当的 Docker 镜像。

自定义：
```bash
vim .bjarne/Dockerfile       # 根据需要编辑
bjarne --rebuild             # 使用更改重新构建
```

需要 [Docker](https://docs.docker.com/get-docker/)。

## 提示词目录

Bjarne 的所有 AI 提示词都存储在 `prompts/` 目录中（相对于 bjarne 脚本）。

### 目录结构

```
prompts/
├── plan.md              - 主规划阶段提示词
├── execute.md           - 代码执行阶段提示词
├── review.md            - 评审和验证提示词
├── fix.md               - 错误修复提示词
├── init.md              - 项目初始化提示词
├── refresh.md           - 上下文刷新提示词
├── decompose.md         - 任务分解提示词
├── finalize-worktree.md - 支持 git worktree 的最终化
├── finalize.md          - 标准最终化提示词
├── batch-plan.md.template     - 批量模式规划（需要变量替换）
├── batch-execute.md           - 批量模式执行
├── batch-review.md            - 批量模式评审
├── batch-fix.md               - 批量模式修复
├── dockerfile.template        - Dockerfile 生成（需要变量替换）
├── verbose-rules.template     - 详细输出规则（需要变量替换）
└── README.md             - 提示词系统文档
```

### 文件类型

- `*.md` - 静态提示词（按原样加载）
- `*.template` - 需要变量替换的提示词（使用 `envsubst`）

### 自定义提示词

你可以通过编辑 `prompts/` 目录中的文件来自定义 Bjarne 的行为：

1. **找到相关提示词文件**
2. **编辑内容** - 对于 `*.template` 文件，使用 `$VAR_NAME` 格式表示变量
3. **保存更改** - Bjarne 会在下次运行时自动加载更新的提示词

**注意：** 编辑提示词可能会影响 Bjarne 的行为。建议在自定义之前备份原始文件。

详细文档请参阅 [prompts/README.md](prompts/README.md)。

## 要求

- 已安装并认证 [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
- **macOS 或 Linux**（Windows 用户：使用 [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)）
- [Docker](https://docs.docker.com/get-docker/)（可选，用于安全模式）

## 所有文件参考

| 文件 | 用途 |
|------|------|
| `CONTEXT.md` | 静态项目参考 |
| `TASKS.md` | 复选框任务列表（主要状态） |
| `specs/` | 详细规范 |
| `.task` | 当前任务状态（临时） |
| `.bjarne/Dockerfile` | Docker 配置（安全模式） |
| `.bjarne/logs/` | 会话日志和故障详情 |
| `.bjarne/tasks/<id>/` | 任务模式状态（隔离，自动清理） |
| `prompts/` | AI 提示词模板 |

## 自动更新

Bjarne 每 2 天检查一次更新：

```
bjarne 有新版本可用。
是否更新? [y/N]
```

```bash
bjarne --update                # 立即检查更新
bjarne --disable-auto-update   # 禁用
bjarne --enable-auto-update    # 重新启用
```

## 站在 Ralph 的肩膀上

Bjarne 受到 [Ralph Wiggum 技术](https://ghuntley.com/ralph/) 的启发，由 [Geoffrey Huntley](https://ghuntley.com/) 创建 - 他是澳大利亚农村的一位山羊农民，证明了"愚蠢的事情可以出奇地有效"。

最初的 Ralph 美丽而简单：一个 bash 循环，持续运行 Claude 直到工作完成。Geoffrey 曾经连续运行它三个月，醒来时发现一个功能完整的编程语言，其中包含 Gen Z 俚语关键字。

Bjarne 为混乱添加了结构 - 任务规划、代码审查和修复循环 - 但精神是一样的：*天真的坚持会胜利*。

## 贡献

欢迎贡献！特别是：
- 新的提示词模板
- 技术栈检测改进
- Docker 镜像优化
- 文档翻译

## 许可证

MIT
