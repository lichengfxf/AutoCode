# 评审阶段（批处理模式）

**重要提示：这是自动化流程的第3步（共4步：规划 → 执行 → 评审 → 修复）**
- 这里没有人工介入 - 你的输出直接进入修复阶段
- 不要问"你想让我修复这个吗？"这类问题
- 不要主动提出修改 - 只需记录发现
- 修复阶段会自动处理你报告的所有内容
- 直接、实事求是 - 不需要客套话

根据 .task文件 计划评审实现结果 - 验证所有批处理的任务。

## 1. 验证所有结果（最重要！）
从 .task 文件中阅读 EXPECTED_OUTCOMES 和 OUTCOME_VERIFICATION。
对于每个列出的任务，实际运行验证步骤：
- 如果说"按钮存在且 href=/login" → grep/搜索它
- 如果说"API 返回 200" → curl 端点
- 如果说"显示错误消息" → 检查组件是否渲染它
- 如果说"文件创建于 X" → 验证文件存在

**分别跟踪每个任务的结果：**
- 任务 1: ✅ 达成 / ❌ 未达成
- 任务 2: ✅ 达成 / ❌ 未达成
- 等等

**如果任何结果未达成**：这是 🔴 BLOCKERS - 该任务未完成。

## 2. 检查计划符合性
- 批处理中的所有任务是否都已处理？
- 是否复用了 EXISTING_CODE？
- 是否遵循了 PATTERNS？
- 所有 PLAN 步骤是否完成？

## 自动检测关注领域
根据实现的内容，检查相关领域：

**如果涉及 auth/passwords/tokens/API keys：**
- 输入验证和清理
- 无硬编码密钥
- 安全的令牌处理

**如果涉及 database/SQL：**
- 预处理语句（防止 SQL 注入）
- 正确的错误处理

**如果涉及用户输入/表单：**
- 输入验证
- XSS 防护（转义输出）

**如果涉及 API 端点：**
- 正确的响应格式
- 错误响应
- 身份验证检查

**如果涉及 async/state：**
- 竞态条件检查
- 错误状态处理

**如果涉及 UI：**
- 匹配设计系统（如果存在 specs/DESIGN_SYSTEM.md）
- 可访问性基础

## 运行检查
使用 .task 文件中的 TEST_COMMAND（或从 CONTEXT.md 检测）

## 按类型和严重程度分类问题

### 问题类型：
- 🔧 环境：缺少工具、依赖项、容器配置错误、需要配置
- 💻 代码：bug、逻辑错误、安全问题、缺少错误处理

### 严重程度：
- 🔴 BLOCKERS：安全漏洞、数据丢失风险、崩溃、结果未达成
- 🟡 问题：bug、逻辑错误、缺少错误处理
- 🟢 建议：样式改进、小优化

## 追加到 .task文件：
```
REVIEW_RESULT:
OUTCOMES_ACHIEVED:
- 任务 1: yes/no - [证据]
- 任务 2: yes/no - [证据]
BUILD_PASSED: yes/no
TESTS_PASSED: yes/no

ENVIRONMENT_ISSUES:
- [类型] [描述] → REMEDIATION: [如何修复]

BLOCKERS:
- [如果有 - 包括结果未达成的情况]

ISSUES:
- [如果有]

SUGGESTIONS:
- [如果有，简要]
```

如果一切正常，写入：
```
REVIEW_RESULT:
OUTCOMES_ACHIEVED:
- 任务 1: yes - [简要证明]
- 任务 2: yes - [简要证明]
BUILD_PASSED: yes
TESTS_PASSED: yes
ISSUES: none
```
