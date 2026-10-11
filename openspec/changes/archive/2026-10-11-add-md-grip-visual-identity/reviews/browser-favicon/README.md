# 票据 05：真实预览网页的浏览器标签 favicon 实际观察

票据：`../../tickets/05-browser-favicon-integration.md`（覆盖 OpenSpec 任务 3.3）
日期：2026-10-11；观察环境：本机 macOS 27.0.1 (26A434)，Google Chrome 155.0.8059.39

## 接入事实（非本票改动，来源票据 02）

- `defaults/static/images/favicon.ico` 已是票据 02 交付的三帧 ICO（16/32/48 px），git 显示为 tracked 修改，本票未再改动。
- `defaults/templates/layout.html` 保持原引用 `<link rel="icon" type="image/x-icon" href="/static/images/favicon.ico" />`（模板中唯一图标声明，无其他 icon/manifest 引用）。
- `defaults/embed.go` 保持 `//go:embed static` 整目录嵌入；路由与 embed 规则未动。本票对产品文件零改动。

## 实际构建与静态佐证（非验收替代）

- `make build` → `bin/md-grip`（2026-10-11 15:29 本地构建，`go build -o bin/md-grip .`）。
- 启动真实 CLI：`bin/md-grip --browser=false --host 127.0.0.1 --port 6421 --no-reload .`（目录模式伺服仓库根，新实例）。
- 服务端页面 `http://127.0.0.1:6421/README.md` 的 HTML head 含原样 favicon link。
- `GET /static/images/favicon.ico` → `200 OK`，`Content-Type: image/x-icon`，15086 B；响应体 sha256 `bc4918bfb9e4d62067dcee2a7b41ad440b2830b3a511056369e3d4772bf7ffd1` 与仓库内 `defaults/static/images/favicon.ico` 完全一致（embed 直接交付票据 02 已交付的 tracked 未提交资产，无构建期导出步骤）。

## 干净浏览器上下文的真实标签观察（验收证据）

- 浏览器：系统 Chrome，以一次性全新 profile 启动（`open -na "Google Chrome" --args --user-data-dir=/tmp/mdgrip-favicon-profile.TsU83Q --no-first-run --no-default-browser-check "http://127.0.0.1:6421/README.md"`），无旧 favicon 缓存；预览为刚构建的新实例。
- 观察方式：对真实 Chrome 窗口（CGWindowID 3794，含标签条）执行 `screencapture -x -o -l3794`，非页内模拟、非仅 DOM 检查。
- 见 `01-full-window.png`：标签条中 `md-grip - markdown preview` 标签左侧显示蓝色「叠窗」favicon；页面内容预览正常（README 渲染：侧栏、TOC、标题、96 px 品牌图、正文均照旧，深色主题）。
- `02-tab-strip-zoom.png`：标签条 6× 放大，favicon 小尺寸可辨（选定方向 A 的蓝色叠窗轮廓）。
- `03-tab-favicon-zoom.png`：从原始 `01-full-window.png` 的 `(132,10)` 裁出 20×20 px 区域，包含完整的 16 px 标签图标及周边留白，再以最近邻放大 16×。后续审阅发现旧裁剪截断前窗底部，本次只重裁已有实测截图，未重新启动浏览器或改变原始窗口图。
- `04-ico-16-frame-zoom.png`：交付 ICO 的 `[0]` 16 px 帧同倍率放大。
- `05-tab-vs-ico16.png`：左侧为上述完整标签裁剪，右侧为 `04` 的 ICO 16 px 帧同倍率放大并居中补边；两侧均保留完整图形。背景不同，比较同源的蓝色文档轮廓与浅色前窗，不声称标签截图与透明 ICO 合成图逐像素一致。
- `06-favicon-svg-16-zoom.png`：可编辑源文件 `docs/brand/favicon.svg` 直接渲染 16 px 后同倍率放大。
- `07-favicon-svg-vs-ico16.png`：源文件渲染与交付 ICO 16 px 帧并排——轮廓逐像素一致（同方向源文件），确认 ICO 即选定方向的 16 px 适配。

## 边界与未声称项

- 本票验证的是 CLI `md-grip` 打开的真实预览；App 内置工具入口的同一嵌入资源复核由票据 07 完成。
- 未修改缓存策略、路由、模板、embed；未新增外部图标服务、页面脚本或任何永久测试。
- 已执行清理：预览服务进程（PID 40121）已停止、端口 6421 已释放；临时 profile 的 Chrome 实例（主进程 40154）已退出；`/tmp/mdgrip-favicon-profile.TsU83Q` 临时目录已删除。用户默认 profile 的其他 Chrome 窗口未受影响。
