# 票据 06 观察记录：预览网页页脚品牌文案

观察环境（实际页面验收，非静态检查）：

- 产物: `make build` 实际执行（`go build -o bin/md-grip .`），真实 `bin/md-grip` 启动。
- 服务: 目录模式伺服仓库根，`--browser=false --no-reload`；两实例分别为 `--bounding-box=true`（端口 6451）与 `--bounding-box=false`（端口 6452），均为全新进程。
- 浏览器: 真实 Chromium（托管 headless，viewport 1280×900），打开 `http://127.0.0.1:<port>/README.md` 实际渲染页面；`page.evaluate` 读取真实 DOM 与计算样式，`page.screenshot` 保存本目录截图。
- 观察后清理: 两个服务进程已停止，端口 6451/6452 已释放（curl 确认 down）。

## 证据

### s1 模板改动面（唯一改动）

`git diff defaults/templates/layout.html` 全量输出（-1/+1，无其他行变更）：

```diff
@@ -322,7 +322,7 @@
     {{if .BoundingBox}}
     <footer class="container footer">
       <div class="docs-footer-inner">
-        Made with &hearts; by chrishrb
+        Rendered with MDGrip
       </div>
     </footer>
     {{end}}
```

文案按 Spec「纯文本 `Rendered with MDGrip`」执行（用户确认去掉 `&hearts;` 实体）。footer DOM（`footer.container.footer` > `div.docs-footer-inner`）、`{{if .BoundingBox}}` 条件及相关 CSS 文件均未改动；全仓 grep 确认页脚旧文案唯一出现处即该行。

### s2 `--bounding-box=true`（原显示条件成立）— 真实页面观察

`page.evaluate` 实测（`01/02/03` 截图）：

- footer 在原位置: `body` 子元素顺序 `BUTTON.theme-toggle → DIV.docs-shell… → FOOTER.container.footer → SCRIPT`，footer 为 body 最后一个可见元素，位于 `.docs-shell` 之后、`<script>` 之前——与改前结构一致。
- footer 文本精确为 `Rendered with MDGrip`（`textContent.trim()`），文本节点数 1；footer 内无 `a`/`svg`/`img`（未新增链接、图标）；footer 文本不含 `chrishrb`/`Made with`/`♥`（旧文案已不在页脚；页面正文的 `chrishrb/go-grip` 为 README 自身上游来源说明，属保护范围，见 s4）。
- 样式来自未改动的既有 CSS 命中: `.footer`（`github-markdown-light.css` / `github-markdown-dark.css`）、`.docs-footer-inner`（`docs-layout.css`）；计算样式 `position: static`、`text-align: center`（深色背景下页面可见为居中页脚文字，见 `02-bb-true-footer-zoom.png`）。
- 内容预览正常: `h1 md-grip`、69 个段落、侧栏、TOC、品牌图标（票据 04 交付）均照旧。

截图: `01-bb-true-top.png`（首屏）、`02-bb-true-footer-zoom.png`（滚动到页脚，页脚文字居中显示于页面底部）、`03-bb-true-full.png`（整页长图）。

### s3 `--bounding-box=false`（原隐藏条件不成立）— 真实页面观察

`page.evaluate` 实测（`04/05/06` 截图）：

- footer 缺席: 无 `footer.footer`、无 `.docs-footer-inner` 元素；页面任意可见文本不含 `Rendered with MDGrip`（未因文案替换新增常驻页脚）。
- `body` 子元素顺序 `BUTTON.theme-toggle → DIV.docs-shell… → SCRIPT`——未新增布局或展示条件；`.container-inner` 亦不存在（既有条件本身状态，未改）。
- 内容预览正常: `h1 md-grip`、69 个段落、侧栏、TOC、品牌图标照旧。

截图: `04-bb-false-top.png`（首屏）、`05-bb-false-bottom.png`（页面底部：仅 `NEXT AGENTS.md` 页脚导航，其下无页脚）、`06-bb-false-full.png`（整页长图）。

### s4 归属与来源保留

- `git status --porcelain LICENSE` → 无输出（LICENSE 与 HEAD 逐字一致，上游版权 `Copyright (c) 2024 Christoph Herb`、derived-from 注与 vendored 资产许可注原样保留）。
- `git diff README.md` → 仅票据 04 已交付的 2 行图标插入（本票起点即已存在的基线改动），本票未触碰 README；项目来源说明（fork 自 `chrishrb/go-grip`、MIT 保留版权、不回提 PR）原样。
- 全仓替换未执行: 除该模板行外，`docs/`、LICENSE、README 及其他文件中的 `chrishrb` 均未改动（`git status` 变更清单仅本票 1 行 + 前序票据/无关用户改动，见下）。

### s5 测试与构建边界

- `go test ./...` 全部 ok（`cmd`、`internal`、`internal/hotreload` 及各 pkg；根/defaults 无测试文件）；现有测试不引用页脚文案（全仓 `*_test.go` 无 `Made with`/`chrishrb` 页脚断言，`pkg/ghissue` 中的 `chrishrb/go-grip` 为上游 repo fixture，与页脚无关）。
- 本票未新增任何永久测试（票据明确禁止文案/源码文字断言类测试）；未新增链接、图标、配置、状态机制或常驻页脚。

## 变更清单（本票）

- `defaults/templates/layout.html`（-1/+1 行页脚文案）——本票唯一产品文件改动。
- `openspec/changes/add-md-grip-visual-identity/reviews/footer/`（本 README + 6 张截图，新增证据材料）。
- 既有与本票无关改动原样保留: `AGENTS.md`、`.agents/skills/tasks-to-tickets/SKILL.md`（用户改动），票据 02/03/04/05 的已交付改动（favicon.ico、README 图标插入、pbxproj、AppDelegate.swift、Assets.xcassets、docs/brand/、前序 reviews 目录）。
- 无 Git 固定点: 本票起点工作树即含上述前序票未提交改动，本票完整变更面以 s1 的单行 diff 与上述新增证据目录为界（未声称穷尽全仓 diff）。

## 范围与未验证项

- 本票验收的两个真实页面场景（CLI 入口、bounding-box 成立/不成立）均已实际观察。
- App 内置工具入口的页脚复核、双架构打包交付复核属票据 07 职责，本票不声称完成。
- 观察为本地 headless Chromium；未声称远端 GitHub 或其他浏览器环境结果。
