# 05: 真实预览网页的浏览器标签显示新图标

Status: done
Blocked by: 02-refined-brand-assets
Covers OpenSpec tasks: 3.3
Behavior source: ../specs/project-visual-identity/spec.md
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

用户用实际构建的 md-grip 打开 Markdown 预览时，浏览器标签显示选定方向的小尺寸 favicon，页面仍正常预览内容。

## Context

- 完成 `Browser preview uses the shared favicon` 的 `Open a real Markdown preview`，贡献共同视觉身份、正常 Go 构建消费交付资产与实际展示验收。
- 使用 design Decisions 4 的多尺寸 ICO，以及 Decisions 5、6 的原路径接入和真实标签验收；已有模板引用和整个 static 目录的 Go embed 可直接交付该文件。
- 票据 02 已将 ICO 导出到消费位置；本票负责实际构建、嵌入消费及标签展示验证，而不是再造另一套 favicon。无需等待 macOS、README 或页脚票完成。

## Acceptance

- [x] 确认使用票据 02 的最终多尺寸 ICO，保留现有引用路径、模板 link、路由与 embed 规则，不增加外部图标服务或页面脚本。
- [x] 执行 `make build`，用实际构建的 CLI 打开真实 Markdown 内容；正常构建直接消费已交付图标，不运行图像导出步骤。
- [x] 在干净浏览器上下文实际观察标签上的新 favicon，确认它与选定品牌轮廓一致且小尺寸可辨，并检查内容预览正常；不能只下载 ICO、检查 link 或以页内模拟图代替标签展示。
- [x] 若旧缓存影响显示，用新预览实例和干净浏览器上下文验证实际资源，不修改产品缓存策略；记录观察环境及可见标签证据，无法观察标签时不得报视觉通过。
- [x] 同票记录接入与 smoke 证据，不新增资源副本、路径引用或二进制内容比对类永久测试，不把本票完成等同于 App 内置工具和 DMG 全部完成验收。

## Closure record

交付物：仅证据材料——`../reviews/browser-favicon/`（README.md 观察记录 + 7 张证据图：`01-full-window.png` 真实 Chrome 窗口含标签条、`02-tab-strip-zoom.png` 标签条 6×、`03-tab-favicon-zoom.png` 标签 favicon 16×、`04-ico-16-frame-zoom.png` 交付 ICO 16 px 帧 16×、`05-tab-vs-ico16.png` 标签实际显示 vs ICO 帧、`06-favicon-svg-16-zoom.png` 源文件 16 px 渲染、`07-favicon-svg-vs-ico16.png` 源文件 vs ICO 帧逐像素一致）。**产品代码/模板/embed/路由零改动**；`defaults/static/images/favicon.ico` 的 tracked 修改为票据 02 的既存交付，本票未动。

实测（详见 `../reviews/browser-favicon/README.md`）：`make build` 产出 `bin/md-grip` 并以新实例伺服仓库根（`--browser=false --port 6421 --no-reload`）；`GET /README.md` 页面 head 含原样 favicon link，`GET /static/images/favicon.ico` 200、`image/x-icon`、15086 B，响应体 sha256 与仓库内交付 ICO 完全一致；`magick identify` 确认三帧 16/32/48。真实观察：Chrome 155.0.8059.39 / macOS 27.0.1，一次性全新 profile（`/tmp/mdgrip-favicon-profile.TsU83Q`，无旧缓存），`screencapture -l` 捕获真实窗口（CGWindowID 3794）含标签条——标签实际显示蓝色「叠窗」favicon 且小尺寸可辨，README 预览内容正常（侧栏/TOC/品牌图/正文照旧）；标签显示 vs ICO 16 px 帧 vs `docs/brand/favicon.svg` 16 px 源渲染轮廓一致。未修改缓存策略，无外部图标服务、页面脚本或任何新增永久测试（全仓 `*_test.go` 无 favicon 引用）。观察后已实际清理：服务停止、端口释放、临时 Chrome 实例退出并删除临时 profile；用户默认 profile 窗口未受影响。

独立审查：Standards 轴 PASS（0 blocking；1 条 P3 建议性发现——证据记录将 ICO 误述为「已提交资产」，已按最小修正改为「票据 02 已交付的 tracked 未提交资产」）；Spec 轴 PASS（0 blocking / 0 advisory），两轴均逐项核对 5 条验收为 OBSERVED/SUPPORTED，并确认任务 3.3 集成态验收标准完全满足。两轴覆盖限制：构建/HTTP/哈希/截图为实施者提供而非重跑；无票据起点 Git 固定点，零产品改动结论基于 `git status/diff` 的只读核对与本票清单；App 内置工具入口与打包交付复核属票据 07。

变更清单：`reviews/browser-favicon/` 8 个新文件；无其他改动。任务 3.3 复选框已勾选（本票是 3.3 的唯一实现分发票据，集成态验收标准已全部实际观察；票据 07 仍将按其职责复核内置工具入口）。未 commit、未同步主 spec、未归档。
