# 03: 原创图标在真实 macOS App 中展示

Status: done
Blocked by: 02-refined-brand-assets
Covers OpenSpec tasks: 3.1
Behavior source: ../specs/project-visual-identity/spec.md
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

真实 MDGrip App 使用原创 template 状态栏图标和 App 图标，用户能在浅深菜单栏及 Finder 中观察它们，现有点击、面板和 accessory 行为保持不变。

## Context

- 完成 `Monochrome menu bar identity` 的 `Use the icon in light and dark menu bars`，贡献 `Application icon accompanies packaged applications` 的图标接入和 `Editable MIT-licensed asset delivery` 的构建消费部分。打包 App 的 `View a packaged application in Finder` 最终场景由票据 07 补齐。
- 使用 design Decisions 3 的 asset catalog 与 template 方式，以及 Decisions 6 的真实菜单栏观察；沿用已指定的 AppIcon 构建配置，不建立手工图标加载路径。
- 本票不依赖 README、favicon 或页脚票据完成；依赖仅是票据 02 的用户确认与最终资源交付。

## Acceptance

- [x] 将 AppIcon 与 StatusBarIcon 的资产目录接入 MDGrip target，配置 macOS 1×/2× 槽位和 template 状态栏资源；`make macos` 成功，构建 App 包含所需图标资源与元数据。
- [x] 以 bundle 资产替换通用系统符号，保留 18 pt 逻辑尺寸、MDGrip 无障碍描述及原 target/action；不为点击生成位图、不添加主题监听、状态机制或系统符号回退。
- [x] 启动真实 App，在浅色与深色菜单栏正常尺寸下实际观察 template 着色和轮廓清晰度，并操作原有面板开关；确认不因图标接入出现 Dock 图标。
- [x] 在 Finder 实际观察构建 App 的彩色图标，不能只以 asset catalog 编译成功判定系统展示正确；记录观察环境和图片或操作结果。
- [x] 正常 App 构建直接消费已交付资产，不加入设计工具或导出命令依赖；不修改会话、Finder Services 或预览逻辑。记录本票接入与验证说明，不新增资源引用断言类永久测试。
- [x] 不将本票开发构建观察声称为双架构 DMG 的最终验收；后者仍由票据 07 检查。

## Closure record

交付物：`Assets.xcassets/Contents.json`、`AppIcon.appiconset/Contents.json`（macOS idiom 16/32/128/256/512 pt 1×/2× 共 10 槽；32→`icon_16x16@2x`、256→`icon_128x128@2x`、512→`icon_256x256@2x` 同像素共用，未新增 PNG 副本）、`StatusBarIcon.imageset/Contents.json`（1×=18px / 2×=36px，`template-rendering-intent: template`）；`project.pbxproj` 按既有 `10A1B2CA…` 引用风格新增 `Assets.xcassets` fileRef（`…E3`）+ MDGrip group + Resources 阶段条目（`…C3`），其余设置未动；`AppDelegate.swift` `setupStatusItem()` 图像来源换为 `NSImage(named: "StatusBarIcon")` + 代码层 `accessibilityDescription = "MDGrip"`，保留 target/action，无符号回退/主题监听/状态机/手工 icns 路径。

实测（详见 `../reviews/integration/README.md`，15 个截图/证据文件）：`make macos` BUILD SUCCEEDED；产物 `Resources/` 含 `Assets.car`+`AppIcon.icns`、内置 `Info.plist` `CFBundleIconName=AppIcon`、`LSUIElement=true` 不变；`assetutil` 核对 AppIcon rendition 全集与 StatusBarIcon 18/36 两条 rendition 的 `"Template Mode": "template"`。真实 App：深色栏白 template 图形（AX description="MDGrip"）、点按开/关原面板（两种外观）、运行中无 Dock 项（`lsappinfo type="UIElement"` + Dock 截图）；Finder 图标视图见构建产物彩色 App 图标。浅色栏底经「辅助功能→显示→降低透明度」AXUI 实际开启达成（栏面 luma 234、黑色状态图形 glyph min=32，`menubar-light-solid*.png`），观察结束后该开关点回 0，外观深色、壁纸 Chroma Red、System Settings 退出、App 退出——临时改动全还原。`make macos-test` 95 tests / 0 failures 保持绿色；无新增永久测试。

独立审查：Standards 轴 0 blocking / 0 advisory；Spec 轴首审 1 blocking（缺实际浅色栏底观察）→ 补齐浅色实底栏实测并修订证据记录后复审 PASS（0 blocking / 0 advisory / 0 未决范围决策）。两轴均声明覆盖限制（未重跑构建/测试、AX/像素数据未独立复测、无全仓 diff 基线、双架构打包验收不在本票）。

变更清单：三个新 `Contents.json`、`project.pbxproj`、`AppDelegate.swift`、`reviews/integration/`（README + 15 png）。既有与本票无关改动（`AGENTS.md`、`.agents/skills/tasks-to-tickets/SKILL.md`、票据 02 的 favicon 替换）原样保留。未 commit、未同步主 spec、未归档；任务 3.1 复选框已并勾。
