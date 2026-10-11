# 04: 仓库 README 顶部展示品牌图标

Status: done
Blocked by: 02-refined-brand-assets
Covers OpenSpec tasks: 3.2
Behavior source: ../specs/project-visual-identity/spec.md
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

用户阅读 README 时，在原标题和介绍之间看到清晰的 MDGrip 品牌图标；原有内容、布局结构及来源说明保持不变。

## Context

- 完成 `Minimal repository icon integration` 的 `Read the repository introduction in either theme`，贡献共同视觉身份与实际展示验收。
- 使用 design Decisions 5 的单个本地 PNG、96 px 显示宽度和 MDGrip alt，以及 Decisions 6 的真实浏览器观察和环境区分。
- 本票不依赖 macOS 或浏览器 favicon 接入，只依赖票据 02 的最终平面资源交付。

## Acceptance

- [x] 在原文字标题之后、介绍之前最小插入本地图标引用，显示宽度 96 px、alt 为 MDGrip，不新增字标、主题切换图片或社交预览素材。
- [x] 在浏览器实际渲染 README，分别观察浅色和深色背景下的图标及标题附近布局；记录实际观察环境，不用单独图片查看代替 README 展示。
- [x] 现有标题、介绍、章节、截图、上游来源、版权与安装及候选分发说明保持不变，不调整 GitHub 头像、About、topics 或仓库设置。
- [x] 同票记录展示证据；只能本地渲染时明确说明，不声称已观察 GitHub 远端页面。不新增断言 README 文案或图片引用的永久测试。

## Closure record

交付物：`README.md` 标题行后、介绍段前插入单行 `<img src="docs/brand/mdgrip.png" alt="MDGrip" width="96" />`（`git diff --numstat` 实测 README 仅 +2/−0：img 行及其空行；Markdown 图片语法无法设置显示宽度，按 design Decision 5 用内联 HTML）；`../reviews/readme/`（README.md 观察记录 + 4 张真实浏览器截图：`01-dark-top.png`、`02-dark-icon.png`、`03-light-top.png`、`04-light-icon.png`）。

实测：`make build` 产出 `bin/md-grip`，目录模式伺服仓库根（`--browser=false --port 6419 --no-reload`），非 markdown 路径走内置 fileServer，`/docs/brand/mdgrip.png` 实际加载成功；真实 Chromium（托管 headless，视口 1280×900）打开 `http://localhost:6419/README.md`，`page.evaluate` 实测：alt `MDGrip`、natural 512×512（票据 02 透明 PNG）、渲染 rect 精确 96×96、为 `<h1>md-grip</h1>` 的下一兄弟元素且位于介绍段之前；初始深色背景 `rgb(13,17,23)`，点击页面真实 UI `#theme-toggle`（☾/Theme: Dark）切换浅色后 rect 不变；两组截图均见图标可辨认、透明 alpha 正常、标题/介绍/目录照旧。观察环境为**本地渲染**（md-grip 本地 + 真实 Chromium），记录与截图均明写；**未声称观察 GitHub 远端页面**（未 push，远端最终展示属未验证环境）。未改动 GitHub 头像、About、topics、仓库设置（未执行任何远端/设置操作）。

测试边界：未新增任何永久测试（票据明确禁止 README 文案/图片引用断言类测试）；全部现有 Go 测试使用 temp-dir 内自建 README fixture，不读取仓库真实 README，本行插入不触碰任何测试。既有与本票无关改动（AGENTS.md、`.agents/skills/tasks-to-tickets/SKILL.md`、票据 02/03 的 favicon/pbxproj/AppDelegate/Assets.xcassets/docs-brand 交付）原样保留。

独立审查：Standards 与 Spec 两轴并行独立评审，均 **PASS**（各 0 blocking / 0 advisory / 0 未决范围决策）。两轴覆盖限制：报告的检查未重跑（make build、本地服务器、Chromium 渲染/测量/切换、无永久测试变更均为实施者证据）；远端 GitHub 渲染未观察（证据已限定本地）；未建立超出报告 git 事实的完整 diff 基线。

变更清单：`README.md`（+2 行）与 `reviews/readme/`（README.md + 4 png，均为新增证据材料）。任务 3.2 复选框已勾选（本票是 3.2 的唯一分发票据，整体验证标准已在集成态全部实际观察）。未 commit、未同步主 spec、未归档；后续票据（05 浏览器 favicon、06 页脚文案、07 打包端到端验收）另行获批实施。
