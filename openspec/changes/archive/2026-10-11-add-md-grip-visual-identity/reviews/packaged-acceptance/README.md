# 打包产物与四类品牌展示端到端验收记录（票据 07）

**性质：本变更加入后的打包/集成验收记录（verification-only）**——不补造产品功能，不发布新版本，不改变签名、公证或安装信任验证边界，不执行提交、spec 同步或归档。观察环境：本机（macOS 27.0.1，arm64，主屏 2560×1440，深色外观为用户默认状态），产物为仓库现有 `make macos-candidate` 流程生成的候选（ad-hoc 签名，未通知/未公证）。观察时间 2026-10-11（本目录文件时间戳）。

本票仅做跨场景与产物复核；各场景的初次验证属于票据 03/04/05/06，汇总见第 6 节索引表。

## 1. 双架构候选打包与既有检查（实际执行）

| 检查 | 观察结果 |
|---|---|
| `make macos-candidate`（实际执行） | arm64 与 x86_64 两次 archive 均 `** ARCHIVE SUCCEEDED **`；DMG 建立：`macos/.build/candidate/MDGrip-arm64.dmg`、`MDGrip-x86_64.dmg` |
| `macos-candidate-check`（既有检查原样执行） | 两种架构均 `candidate checks passed`：`codesign --verify --strict` 对 App 与内置 `md-grip` 通过；标识符 `com.showgp.MDGrip` / `com.showgp.MDGrip.md-grip` 精确匹配；`Signature=adhoc`；`lipo -verify_arch` 证实各二进制仅含目标架构、不含对方 slice |
| 签名/公证/安装信任边界 | 未改动；未执行通知公证，未安装信任验证（边界保持既有候选流程） |

## 2. DMG 挂载的结构检查（两种架构资源，非视觉结论）

只读挂载两枚 DMG 后逐包检查：

| 检查 | arm64 | x86_64 |
|---|---|---|
| `Contents/Resources/` 含 `Assets.car` | ✓（136 552 B） | ✓（136 552 B；`Assets.car` SHA-256 **与 arm64 完全一致**：`baed096d…`） |
| `Contents/Resources/` 含 `AppIcon.icns` | ✓（19 386 B） | ✓（19 386 B） |
| `Info.plist` `CFBundleIconName` | `AppIcon`（实测 `plutil -extract CFBundleIconName raw`） | `AppIcon`（同法实测） |
| `assetutil --info Assets.car` renditions | AppIcon 16/32/64/128/256/512/1024 px 全组（同名像素槽共用文件映射保持） | 与 arm64（同一 car）一致 |

StatusBarIcon 两条 rendition 均为 18×18@1x、36×36@2x 且 `"Template Mode": "template"`。DMG 内 `/Applications` symlink 与既有打包形态未变。挂载后已 `hdiutil detach` 全部设备。

**字节检查所用命令（本票实际执行，留档）**：
- `shasum -a 256 /tmp/mdgrip-dmg-arm64/…/Assets.car …/x86_64/…/Assets.car`（两行同值 → 上表 SHA-256 相等）；
- `curl …/static/images/favicon.ico` 落盘后 `shasum -a 256` 与 `defaults/static/images/favicon.ico` 两行同值 → 服务 ICO 与交付 ICO 一致；
- `python3`：`open('bin/md-grip','rb').read().find(open('defaults/static/images/favicon.ico','rb').read())` 为命中位置 → 嵌入字节存在；同法验证 `b'Rendered with MDGrip' in bin`。

**边界**：此节为结构检查；文件存在与 rendition 完整不替代实际展示观察（第 4 节）。

## 3. 正常构建入口不含图像导出步骤；实际构建消费已交付资产

| 检查 | 观察结果 |
|---|---|
| 文本检查（本票实际执行） | `rsvg-convert`/`magick`/`ImageMagick`/`iconutil` 生成引用在 `Makefile`、`macos/Scripts/build-md-grip.sh`、`.github/workflows/build.yml`、`.github/workflows/release.yml`、`cmd/*.go`、`defaults/*.go` 中命中数为 **0** |
| Xcode 打包 Script 阶段（`build-md-grip.sh`） | 只有 `go build`、`lipo`、`codesign`（本票 `make macos-candidate` 执行中实际运行） |
| `make build`（实际执行） | `go build -o bin/md-grip .` 成功，全程未调用任何图像工具 |
| 已交付资产被实际消费 | `bin/md-grip` 内部按字节包含已交付 `defaults/static/images/favicon.ico`（SHA-256 `bc4918bf…`）整段数据与模板文案 `Rendered with MDGrip`（embed 消费实测）；App 包 Assets.car 由已交付 PNG 编译得出（rendition 组核对，票 03 同方法） |

**边界**：本机恰装有维护工具这一事实不能证明构建无依赖；以上以构建入口文本检查 + 实际构建运行为证。维护说明（`docs/brand/README.md`）与命令属资产维护路径，不进入任何构建目标。

## 4. 本机实际运行观察（arm64 打包 App，`/Applications`）

安装方式：只读挂载 arm64 DMG 后，将挂载载荷 `/tmp/mdgrip-dmg-arm64/MDGrip.app`（即 DMG 内打包产物本体）经 `ditto` 复制入 `/Applications`，`codesign --verify --strict` 通过；观察后**已删除该副本**并确认 `/Applications` 无残留。面板打开/关闭两张证据为同日复观察重拍（以 `macos/.build/MDGrip-arm64.xcarchive/Products/Applications/MDGrip.app` 重装配后复验，设定一致），并已按隐私卫生处理：裁剪至面板/状态项区域，关闭态背景统一虚化；面板 Recent 列表中的既有本机路径为该 bundle id 的历史用户偏好，非本变更交付物，原样呈现。

| 场景 | 证据 | 观察 |
|---|---|---|
| Finder / 应用程序目录中的彩色 App 图标 | `01-finder-applications-icon.png`（图标视图整幅）、`02-finder-icon-zoom.png`（×5 特写） | `/Applications` 目录内 `MDGrip.app` 显示**蓝色圆角 tile + 浅色叠窗图形**的成品彩色图标，非通用白色应用图框；运行进程 `txt` 路径实测为 `/Applications/MDGrip.app/Contents/MacOS/MDGrip` |
| 打包 App 状态栏正常展示 | `03-packaged-menubar-zoom.png`（×8） | 深色菜单栏下状态项为**白色 template 着色的“叠窗”图形**，相邻 VLC 图标可对照；AppleScript 读得 description=`MDGrip`、position `{1681,3}`、size `{36,24}`（18 pt 逻辑尺寸） |
| 既有面板交互 | `04-packaged-popover-open.png` → `05-packaged-popover-closed.png` | 点按状态项 → 原面板打开（Sessions/Recent/Launch at login，锚定状态项下方）；再次点按 → 面板关闭；全程无新代码 |
| 无 Dock 常驻 | `06-packaged-dock-running.png`（运行中 Dock 条，低分辨率全宽仅作方位参考）；两次 `lsappinfo info -only ApplicationType MDGrip` 原始输出含 `type="UIElement"`（实际命令输出留档如下） | 运行 Pid 43206 时 Dock 无 MDGrip 图块；`lsappinfo info -only ApplicationType MDGrip` 实际输出关键行：`type="UIElement" flavor=[ NULL ]`（两次一致）；打包产物 `Info.plist` `LSUIElement=true`（第 2 节快检，复检记录同票 03 方法） |

**边界**：本机为 arm64 —— 实际启动与上述观察仅针对 arm64 产物；x86_64 产物停留在第 2 节结构检查（设计 Decisions 6：本机视觉结果不代表另一种硬件运行验证）。未进行 Rosetta 启动尝试，未声称 clean-install 或其他硬件验证。

## 5. 内置工具入口与页脚（打包 App 内置 md-grip，真实浏览器）

观察方式：以 `/Applications/MDGrip.app/Contents/MacOS/md-grip`（打包内置工具二进制）在仓库 README 上分别伺服 `--bounding-box=true`（:6431）与 `--bounding-box=false`（:6432）；一次性全新 Chrome profile（`/tmp/mdgrip-packaged-profile`，无缓存），真实 Chrome 窗口观察后实例退出并删除。

| 场景 | 证据 | 观察 |
|---|---|---|
| 嵌入 favicon 随内置工具交付 | 实际请求测量 | `GET /static/images/favicon.ico` → 200、`15086 B`，响应体 SHA-256 与仓库交付 ICO **完全一致**（`bc4918bf…`） |
| 真实浏览器标签 favicon | `07-packaged-tool-tabstrip.png`（×4）、`10-packaged-tool-window-bbtrue.png`（整窗）、`12-packaged-tool-window-bbfalse.png`（双标签均见） | 真实 Chrome 标签显示**蓝色“叠窗”favicon**，标题 `md-grip - markdown preview`；与票 05 CLI 观察的同一轮廓一致——两种入口（CLI、内置工具）消费同一嵌入资源 |
| 页脚显示场景（bb=true） | `08-packaged-tool-footer-bbtrue.png`（页面底部）、`09-packaged-tool-footer-zoom-bbtrue.png`（文本特写） | 页面底部原位置、原样式显示 `Rendered with MDGrip`（居中于窗口内容列），无旧文案 `Made with ♥ by chrishrb`；内容预览（TOC/README 正文/品牌图标）正常 |
| 页脚隐藏场景（bb=false） | `11-packaged-tool-bottom-bbfalse.png`（页面底部）、`12-packaged-tool-window-bbfalse.png`（整窗，URL 可读 `localhost:6432/README.md`） | 页面滚到底部仍**无 footer 元素**、无新旧页脚文案；页面布局未因文案替换改变 |

两个服务观察后已停止（端口连接拒绝证实释放），临时 profile 已删除。

## 6. 跨场景验收证据汇总（各场景初次验证 + 本票复核）

| 场景 | 初次实际观察 | 本票复核 | 层级 |
|---|---|---|---|
| 状态栏深色/浅色菜单栏 | 票 03（真实 App，两态 template：深栏白形/浅栏黑形） | 本票打包 App 深色栏（`03`）复现同一图形；**浅色实底栏为票 03 开发构建观察，本票未在打包候选上重复该项**（见 §7） | 实际观察（浅色承票 03） |
| Finder / 应用程序目录 | 票 03 开发构建 Finder 观察 | 本票**打包产物** `/Applications` 观察（`01`/`02`） | 实际观察 |
| README 浅/深背景 | 票 04（本地渲染 + 4 截图） | 引用票 04 证据，未重复观察 | 实际观察（票 04） |
| 浏览器标签 favicon | 票 05（CLI 入口，干净 profile 真实窗口） | 本票内置工具入口真实标签（`07`/`10`/`12`） | 实际观察 |
| 页脚显示/隐藏 | 票 06（CLI 入口，两 flag 实际页面） | 本票内置工具入口两 flag（`08`/`09`/`11`/`12`） | 实际观察 |
| 打包资源（双架构） | — | 本票 DMG 结构检查（第 2 节） | 结构检查 |
| 候选评审模拟图 | 票 01/02 | **不作为最终验收**（沿用票 02 边界声明） | 模拟展示（限定） |

四类图标同源核对（本票观察 + 前票证据）：状态栏（单色 template）、App（蓝 tile）、README（512 透明 PNG）、favicon（ICO 16 帧）四景为同一“文档+预览窗融合”核心轮廓，本票在 Finder 图标（`02`）、状态栏（`03`）与真实标签 favicon（`07`）同帧/同机复现一致的“叠窗”构造。资产维护链（`docs/brand/` 四个 SVG 源文件、`docs/brand/README.md` 源文件映射/工具版本/导出命令/MIT 说明）原样在库；本票实测四个 SVG 无 `<text>` 元素、无外部字体/链接图片引用（仅 SVG 命名空间 URL），未引入独立许可或副本引用。

版权与来源保留：`LICENSE` 与 HEAD 一致（`git status` 无输出）；`README.md` 相对 baseline 仅 +2 行（票 04 图标行及其空行）；`defaults/templates/layout.html` 仅 −1/+1（票 06 指定文案行）——本票未改这些文件。

## 7. 未验证与排除项（保持如实区分）

- **x86_64 产物实际运行**：未在本机观察（第 2 节为资源结构检查；设计 Decisions 6 的既有边界）。
- **通知公证 / 其他硬件 / clean-install 安装信任**：未执行、不声称（既有候选流程边界保持）。
- **README 远端 GitHub 渲染**：未 push，远端最终展示属未验证环境（票 04 边界顺延）。
- 本机菜单栏浅色实底状态由票 03 记录；本票未重复该项。

## 8. 变更清单（无 Git 深度基线的观察清单）

- 新增：本目录 12 张截图/证据 + 本 README。全部为评审材料，非产品代码。
- 未动的既有交付（票 02/03/04/05/06）：`docs/brand/`、`Assets.xcassets/`、`project.pbxproj`、`AppDelegate.swift`、`README.md`、`layout.html`、`favicon.ico` 原样保留；`AGENTS.md`、`.agents/skills/tasks-to-tickets/SKILL.md` 为与本票无关的用户改动，保留。
- 未新增任何永久测试；无 commit、无 spec 同步、无归档、无新版本产物发布（`bin/md-grip` 与 `macos/.build/` 为本机构建产物目录，不入库）。

## 9. 验收对照（票 07 清单 → 证据）

| 票据验收项 | 结果 |
|---|---|
| 执行现有 `make macos-candidate`，双架构候选 + 既有签名/标识符/单架构检查 | ✓ 第 1 节 |
| 挂载两种 DMG 检查图标元数据与资源 | ✓ 第 2 节 |
| 本机可运行架构启动打包 App；Finder 与应用程序目录观察彩色图标；状态栏与既有行为 | ✓ 第 4 节（arm64；x86_64 结构检查） |
| 正常构建入口无图像导出步骤；实际构建消费已交付资产并记录证据 | ✓ 第 3 节 |
| 内置工具真实预览 favicon + 页脚；两种显示条件保持原契约；结合 05/06 CLI 证据确认双入口同资源 | ✓ 第 5 节 |
| 跨场景证据汇总与同源/MIT/边界复核 | ✓ 第 6 节 |
| 证据区分观察/结构/模拟/未验证；缺失必需项即保持 open | ✓ 第 6/7 节——必需视觉验收无缺项 |
