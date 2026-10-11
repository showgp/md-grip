# 06: 预览网页页脚使用 MDGrip 工具品牌

Status: done
Blocked by: None
Covers OpenSpec tasks: 3.4
Behavior source: ../specs/project-visual-identity/spec.md
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

真实预览网页在原来会显示页脚的场景中显示 Rendered with MDGrip，在原来隐藏页脚的场景中继续隐藏；不改变页面布局或上游版权与来源记录。

## Context

- 完成 `Preview footer identifies MDGrip without changing attribution records` 的 `Display the updated footer under the existing condition` 和 `Preserve the existing hidden footer behavior`。
- 使用 design Decisions 5 的单处模板文案替换与 Decisions 6 的现有 `--bounding-box` 两种真实页面验收。
- 本票与图标设计、用户候选选择及其他接入无数据依赖；编号不构成阻塞。票据实施仍需单独授权，不能因全部票据已发布而自动执行。

## Acceptance

- [x] 只替换指定页脚文案为 Rendered with MDGrip，保留 footer DOM、相关 CSS 和 `.BoundingBox` 条件，不新增链接、图标、配置或常驻页脚。
- [x] `make build` 后，以 `--bounding-box=true` 打开真实 Markdown 预览并观察页脚：在原位置、样式下显示新文案，不再显示旧文案；页面内容预览正常。
- [x] 以 `--bounding-box=false` 打开真实预览并实际观察页面：仍无页脚，没有因文案替换新增布局或展示条件。
- [x] LICENSE 上游版权和 README 项目来源说明保持不变，不执行全仓作者名替换；保留现有嵌入与分发方式。
- [x] 同票记录两个真实页面的观察证据和版权、来源保留情况；不以模板搜索代替页面验收，不新增固定文案或源码文字断言类永久测试。

## Closure record

交付物：`defaults/templates/layout.html` 单行替换——`{{if .BoundingBox}}` 页脚内 `Made with &hearts; by chrishrb` → `Rendered with MDGrip`（用户批准的纯文本，去掉 `&hearts;` 实体；全仓唯一页脚旧文案出现处，`git diff` 实测 -1/+1 无其他行）；footer DOM（`footer.container.footer` > `div.docs-footer-inner`）、`{{if .BoundingBox}}` 条件及相关 CSS 文件、LICENSE、README 来源说明均未改动。证据材料：`../reviews/footer/`（README.md 观察记录 + 6 张真实页面截图）。

实测：`make build` 产出 `bin/md-grip`；真实 Chromium（托管 headless，1280×900）对本地新实例分别以 `--bounding-box=true`（端口 6451）和 `--bounding-box=false`（6452）打开 `README.md` 实际渲染页面。成立场景：页脚为 body 最后可见元素（`theme-toggle → docs-shell → footer → script` 顺序不变），`.docs-footer-inner` 文本精确为 `Rendered with MDGrip`、单文本节点、无 a/svg/img、不含旧文案；样式命中未改动的既有 CSS 规则（`.footer` @ github-markdown-light/dark.css、`.docs-footer-inner` @ docs-layout.css），居中展示见 `02-bb-true-footer-zoom.png`；内容预览正常（h1/69 段/侧栏/TOC/品牌图标）。不成立场景：无 footer 元素、页面任意文本无 `Rendered with MDGrip`、body 子元素无新增（`05-bb-false-bottom.png` 页面底部仅页脚导航）。LICENSE `git status` 无输出（与 HEAD 一致）；`README.md` 仅含票据 04 既存 2 行图标插入，本票未触碰；未执行全仓作者名替换。`go test ./...` 全部 ok；未新增任何永久测试。观察后两个服务已停止、端口已释放。

文案裁决：Spec 措辞「纯文本 `Rendered with MDGrip`」与原模板的 `&hearts;` 实体存在取舍，实施前经用户确认按纯文本执行（无爱心实体）。

独立审查：Standards 与 Spec 两轴并行独立评审，均 **PASS**（各 0 blocking / 0 advisory / 0 未决范围决策）。两轴覆盖限制：无 Git 固定点，变更面以本票单行 diff + 新增证据目录为界；`make build`/`go test`/浏览器观察为实施者证据，审查未重跑（均如实披露）。App 内置工具入口与双架构打包复核属票据 07 职责，本票不声称完成。

变更清单：`defaults/templates/layout.html`（-1/+1 行）与 `reviews/footer/`（README.md + 6 png，新增）。既有与本票无关改动（AGENTS.md、`.agents/skills/tasks-to-tickets/SKILL.md`、票据 02/03/04/05 已交付改动）原样保留。任务 3.4 复选框已勾选（本票是 3.4 的唯一实现分发票据，集成态验证标准已全部实际观察；票据 07 仍将按其职责复核 App 内置工具入口）。未 commit、未同步主 spec、未归档。
