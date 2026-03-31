<!-- # Oh My Co-Researcher -->

![logo](assets/logo.png)

一个可扩展、自我进化的 Agent 技能包，专为自主 ML 研究设计。就像 oh-my-zsh 之于 shell——从五个核心技能出发，通过 `evolve` 将技能包个性化为你自己的工作流。

## 安装

使用 skills.sh CLI 一键安装：

```bash
npx skills add zy-ning/co-researcher
```

> **AI 代理** — 自主获取并遵循 [`docs/agent-setup.md`](docs/agent-setup.md)。
> **人类用户** — 按以下步骤操作。

### 1. 安装本技能包

推荐方式（skills.sh）：

```bash
npx skills add zy-ning/co-researcher
```

手动安装（备用）：

```bash
git clone <repo-url> oh-my-coresearcher
cd oh-my-coresearcher
./install.sh          # 项目级安装 (.claude/skills/)
./install.sh --global # 或全局安装 (~/.claude/skills/)
```

### 2. ARIS 技能包（必需）

来自 [ARIS](https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep) 的核心研究技能：

```bash
git clone https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep.git
cp -r Auto-claude-code-research-in-sleep/skills/* ~/.claude/skills/
```

| 技能 | 调用方 | 用途 |
|------|--------|------|
| `research-lit` / `arxiv` | `research` | 文献调研 |
| `research-refine` | `research` | 方法与想法精炼 |
| `experiment-plan` | `research` | 实验蓝图 |
| `run-experiment` | `research` | 远程/GPU 实验执行 |
| `result-to-claim` | `research` | 验证结果真正支持的结论 |
| `paper-figure` | `research` | 生成论文图表 |
| `paper-write` | `research` | 完整 LaTeX 论文撰写 |
| `auto-review-loop` | `research`, `review` | 多轮自动审稿 |
| `auto-review-loop-llm` | `review` | 备用审稿者（兼容 OpenAI 接口） |
| `auto-review-loop-minimax` | `review` | 备用审稿者（MiniMax） |

### 3. Codex MCP（`review` 所需）

```bash
npm install -g @openai/codex
codex setup                               # 提示时选择 gpt-5.4 模型
claude mcp add codex -s user -- codex mcp-server
```

若 Codex 不可用，可使用备选方案：`auto-review-loop-llm`（任意 OpenAI 兼容端点）或 `auto-review-loop-minimax`。

### 4. Feynman 技能包（可选）

通过 [Feynman](https://github.com/getcompanion-ai/feynman) 添加论文问答与可复现性审计功能：

```bash
curl -fsSL https://feynman.is/install-skills | bash
feynman alpha login   # 完成 AlphaXiv 一次性认证
```

| 技能 | 调用方 | 用途 |
|------|--------|------|
| `alpha-research` | `research` | 深度论文问答与关联代码库发现 |
| `audit` | `research` | 对比论文声明与公开代码库 |

AlphaXiv CLI 命令：`alpha search`、`alpha ask <问题> <id>`、`alpha fetch <id>`、`alpha repo <id>`。

### 5. LaTeX（可选，生成 PDF 输出时必需）

```bash
# macOS
brew install --cask mactex && brew install poppler
# Ubuntu/Debian
sudo apt install texlive-full latexmk poppler-utils
```

## 新建项目

```bash
cp templates/RESEARCH.md.template RESEARCH.md
```

编辑 Goal 字段，然后运行 `/research` 启动。

## 监督策略控制

使用 `/supervision` 来配置当前项目中 Agent 的自动化/监督强度。

交互流程遵循“先预设，后覆盖”：

1. 选择预设：`manual`、`checkpointed`、`autonomous`、`wild`
2. 按需调整通知事件
3. 按需调整审批门槛
4. 选择停止目标 / 限制条件
5. 配置资源规则
6. 配置想法变化规则
7. 如需持久化，将策略写入 `RESEARCH.md`

策略保存在 `RESEARCH.md` 的 `## Supervision Policy` 段落中，因此保持可读、可手工编辑，并能参与会话恢复。

关键能力包括：

- 在 `checkpointed` 模式下支持“排队审批”，让 agent 在等待审批时继续处理其他已允许的工作
- 按 **Service / API**、**Compute**、**Human / Physical** 三类管理资源边界
- 分别控制想法改进、策略转向、方案妥协时是通知用户还是请求审批
- 提供可选的 `wild` 模式，在达到完成条件或硬边界前持续工作

兼容性说明：如果不存在 `## Supervision Policy`，系统保持当前以确认优先的默认行为，不会破坏旧项目。

完整说明见 [`docs/supervision-system.md`](docs/supervision-system.md)。

## 核心技能

| 技能 | 使用时机 |
|------|----------|
| `research` | 主 agent。读取 RESEARCH.md，推断缺口，调整 TODO，委派合适技能，并可根据可配置的监督策略决定通知、审批、停止目标、资源边界与想法变化处理方式。 |
| `experiment` | 运行 ML 实验：隔离虚拟环境、时间预算、异常处理。支持 BFS 模式进行自主设计空间搜索。 |
| `review` | 对抗性评审，分 FATAL/MAJOR/MINOR 三级。依次回退：Codex → llm → minimax。 |
| `write` | 以 RESEARCH.md 结果为基础撰写论文。内联标注 `[UNGROUNDED]` 和 `[UNVERIFIED]`。 |
| `evolve` | 会话结束时提取经验教训**并**个性化技能包。提出差异补丁——仅由人类合并。 |

## agent 循环原理

`research` 读取项目状态，自主决定下一步：

1. **评估** — 对比 Goal 与 Context，找出缺口（如"实验完成但无论文 TODO"）
2. **提案** — 调整 TODO 列表并等待确认后再行动
3. **执行** — 选取优先级最高的 TODO，委派给生态中合适的技能
4. **循环** — 呈现结果并询问"是否继续？"或提供选项

每次新会话或上下文压缩后，agent 先读取 `RESEARCH.md` 中的 `## Pipeline Status`，约 30 秒内恢复工作状态。

如果 `RESEARCH.md` 中还包含 `## Supervision Policy`，`research` 会据此决定：需要审批后暂停、将审批排队后继续其他允许的工作、仅通知后继续、按资源边界请求帮助，或在达到目标时停止。若该段不存在，则保持现有行为。

## BFS 模式（手动开启）

灵感来自 [karpathy/autoresearch](https://github.com/karpathy/autoresearch)。告诉代理"探索设计空间"或"autoresearch"，它会确认：

- **目标文件** — 唯一允许修改的文件（如 `train.py`）
- **指标** — 可验证的标量目标（如最小化 `val_bpb`）
- **预算** — 每次运行时间（默认 5 分钟）与最大实验次数

随后 `experiment` 自主运行：设计假设 → 提交 → 运行 → 提取指标 → 保留或 `git reset` → 重复。每次运行记录至 `results.tsv`，汇总表格完成后写入 `RESEARCH.md` Context。

默认关闭——仅在明确要求时激活。即使在 `wild` 模式下，BFS 仍然必须遵守显式资源规则、安全边界与完成条件。

## 个性化技能包

`evolve` 提供两种模式：

**会话模式** — 在会话结束时运行。从 RESEARCH.md History 和 git log 中提取可复用经验，提出对相关 SKILL.md 文件的修改建议。

**个性化模式** — 指向任意外部技能或技能包，它将：
1. 读取目标并盘点已安装技能
2. 检查兼容性（名称冲突、缺失工具/MCP、行为冲突）
3. 检测范围重叠，展示与现有技能的差异
4. 集中提问——一次性问完所有问题：替换/合并/跳过哪些，拥有哪些依赖，明确不需要什么
5. 提出仅包含你确认内容的精选补丁

```bash
/evolve                                     # 会话模式
/evolve -- personalize feynman audit skill  # 集成单个外部技能
/evolve -- personalize ~/.claude/skills/    # 审计整个已安装技能包
```

补丁输出至 `lessons/`，满意后应用：

```bash
git apply lessons/YYYYMMDD-personalize-slug.diff
```

技能不会被自动修改，仅由人类合并。

## 进化循环

**研究循环**：`research` 选取 TODO → 委派 → 更新 `RESEARCH.md` → 提出下一步 → 循环。

**技能进化循环**：`evolve`（会话） → `lessons/` → 人工审查 → `git apply` → 下次会话技能更强。

**个性化循环**：发现有用的外部技能 → `evolve`（个性化） → 精选补丁 → 合并 → 技能包持续成长。
