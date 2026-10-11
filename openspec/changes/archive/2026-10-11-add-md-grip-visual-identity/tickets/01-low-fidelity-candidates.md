# 01: 两个低保真方向的可视化比较

Status: done
Blocked by: None
Covers OpenSpec tasks: 1.1
Behavior source: ../specs/project-visual-identity/spec.md
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

用户获得两个可以直接查看和比较的原创低保真方向，在状态栏正常尺寸、App 与仓库场景中选择轮廓与构图；本票不预设用户选择，也不接入任何运行时资源。

## Context

- 以 [proposal](../proposal.md) 和上述 spec 为行为边界。本票贡献 `Shared original visual identity`，交付 `User selection precedes refinement and integration` 的 `Compare candidates before selection` 场景；最终四类资产和 `Refine the selected direction` 由后续票据完成。
- 使用 design Decisions 1 的候选评审方式及 Decisions 3 的状态栏尺寸参照。评审材料放在 `../reviews/candidates/`，不是最终资产目录。
- 当前状态栏仍使用系统符号，README 没有图标。不要为了做候选比较先修改 App、README、favicon 或页脚。

## Acceptance

- [x] 交付两个独立可编辑 SVG 与可直接查看的对比图；每个方向都展示正常尺寸状态栏、App 和仓库场景，不只交付大图或文字说明。
- [x] 以实际渲染图片观察轮廓与构图，状态栏展示包含 18 pt 对应的小尺寸效果；记录小尺寸观察与两方向的具体差异，而不是仅以 SVG 文件存在验收。
- [x] 两方向均遵守 spec 的共同定位和原创约束；评审材料明确标注低保真与模拟展示，不声称完成真实菜单栏或打包 App 验收。
- [x] 附简短评审说明和图片查看入口，说明比较重点及本票尚不确定的最终色值与层次；不提前精修全部候选。
- [x] 本票只完成任务 1.1；交付后停下等待用户选择，不记录虚构选择、不勾选任务 1.2、不开始最终精修或接入。票据关闭仍需独立 Standards/Spec 审查；发布本票不授权实现。

## Closure record

交付物：`../reviews/candidates/` 下 `direction-a.svg`、`direction-b.svg`（可编辑场景板）、`compare-a-vs-b.png`（3040 × 2032 对比图，含真实 18 px 渲染 ×16 像素条）、`README.md`（评审说明与查看入口）；未改动任何运行时资源。验收观察与渲染环境记录于 `../reviews/candidates/README.md`。独立审查：Standards 与 Spec 两轴均通过（各 0 条阻塞发现；各 1 条 P3 建议性发现——×8/×16 放大标注不一致，已按最小修正统一为 ×16 并重建对比图）。任务 1.1 已勾选；任务 1.2 保持未勾，等待用户明确选定方向。
