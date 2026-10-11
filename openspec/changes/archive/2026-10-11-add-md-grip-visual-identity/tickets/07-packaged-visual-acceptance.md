# 07: 打包产物与四类品牌展示的端到端验收

Status: done
Blocked by: 03-macos-icon-integration, 04-readme-brand-integration, 05-browser-favicon-integration, 06-preview-footer-branding
Covers OpenSpec tasks: 4.1, 4.2
Behavior source: ../specs/project-visual-identity/spec.md
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

沿现有候选打包流程验证品牌资产随 App、内置工具与 DMG 正确交付，并汇总真实跨场景展示及页脚验证证据。本票是验证-only 集成例外，不补造产品功能，也不在此发布新版本。

## Context

- 完成 `Application icon accompanies packaged applications` 的 `View a packaged application in Finder`、`Editable MIT-licensed asset delivery` 的 `Build without graphics export tools`，以及 `Acceptance observes actual integrated surfaces` 的 `Record final integration evidence`；复核以下覆盖表中的所有既有贡献，不以其他票据的发布或审批代替验证。
- 使用 design Decisions 6 的结构检查、真实观察和环境区分，以及 Migration Plan 的原有打包与分发边界。
- 票据 03/04/05/06 的实际接入和观察是本票的真实前置条件；票据 02 的源文件与导出交付由 03/04/05 的依赖间接保证，无需增加重复依赖。
- 以下覆盖表仅为审阅索引，不是进度账本。唯一 OpenSpec 进度仍在 `../tasks.md`；全部票据已发布供整体审阅，但未因此获准实施或完成。

## Acceptance

- [x] 执行现有 `make macos-candidate`，生成 arm64 与 x86_64 候选，并通过既有签名、标识符及单架构检查；不改变签名、公证或安装信任验证边界，不新增 Release 流程。
- [x] 挂载两种 DMG，检查其中 App 的图标元数据和资源；在本机可运行架构上启动打包 App，并在 Finder 与应用程序目录实际观察彩色图标，确认状态栏正常展示与既有行为。
- [x] 检查正常 Go/App 构建入口不包含设计或图像导出步骤，并实际构建消费已交付资产；记录构建消费与入口检查证据，不以本地恰好安装维护工具的事实证明无此依赖。
- [x] 对 App 内置工具打开的真实预览观察品牌 favicon 与页脚，结合票据 05/06 的 CLI 观察确认两种入口均消费现有嵌入资源；页脚显示与隐藏场景保持原契约，不只检查工具二进制存在。
- [x] 汇总浅深菜单栏、Finder/应用程序目录、README 浅深背景、浏览器标签、页脚显示/隐藏及打包资源的实际证据；各场景的初次验证仍属于各接入票，本票只做跨场景与产物复核。
- [x] 复核四类图标同源、SVG/导出/维护说明及 MIT 交付，上游来源与版权说明、既有功能及分发边界保持不变；不增加源码文案、资源引用或副本断言类永久测试。
- [x] 证据明确区分实际观察、结构检查、候选模拟图及未验证环境；缺少任何必需视觉验收时保持本票 open，不以构建成功补报通过，也不将本机观察声称为其他硬件或 clean-install 验证。
- [x] 任务仅在所有相关交付及实际验收满足后才可按原 ledger 勾选；票据关闭仍需独立 Standards/Spec 审查。本票不执行提交、规格同步、归档或新版本发布。

## 完整任务覆盖表

以下票据均已发布，Status 均为 open；“已发布”不表示已经实现。

| OpenSpec checkbox | 可观察交付 | 票据 | 发布状态 |
|---|---|---|---|
| 1.1 | 两个低保真方向的可视化比较 | [01](01-low-fidelity-candidates.md) | 已发布 |
| 1.2 | 用户实际选择记录 | [02](02-refined-brand-assets.md) | 已发布 |
| 2.1 | 选定方向四类精修源文件与用户确认 | [02](02-refined-brand-assets.md) | 已发布 |
| 2.2 | 最终导出资产及可执行维护说明 | [02](02-refined-brand-assets.md) | 已发布 |
| 3.1 | 真实 macOS App 图标和菜单栏接入 | [03](03-macos-icon-integration.md) | 已发布 |
| 3.2 | README 顶部浅深背景展示 | [04](04-readme-brand-integration.md) | 已发布 |
| 3.3 | 真实浏览器标签的 favicon | [05](05-browser-favicon-integration.md) | 已发布 |
| 3.4 | 页脚品牌文案与原显示/隐藏行为 | [06](06-preview-footer-branding.md) | 已发布 |
| 4.1 | 双架构候选打包与本机实际展示 | [07](07-packaged-visual-acceptance.md) | 已发布 |
| 4.2 | 跨场景证据与范围复核 | [07](07-packaged-visual-acceptance.md) | 已发布 |

## 完整规格要求及场景覆盖表

所有要求与场景均来自 [project-visual-identity spec](../specs/project-visual-identity/spec.md)，没有未覆盖的要求或场景。多个贡献者时，单个票据完成不代表整个要求完成。

| Requirement | Scenario（完整名称） | 贡献与完成票据 | 发布状态 |
|---|---|---|---|
| Shared original visual identity | Recognize the identity across surfaces；Deliver an independent original identity | 01 提供候选贡献；02 完成四类资产及原创来源；03/04/05 实际接入；07 跨场景复核 | 全部已发布 |
| User selection precedes refinement and integration | Compare candidates before selection；Refine the selected direction | 01 完成比较；02 记录选择并仅精修选定方向；03/04/05 消费选定资产 | 全部已发布 |
| Monochrome menu bar identity | Use the icon in light and dark menu bars | 03 实际观察与交互；07 打包产物复核 | 全部已发布 |
| Application icon accompanies packaged applications | View a packaged application in Finder | 02 交付资产；03 接入与开发产物观察；07 完成打包 App 场景 | 全部已发布 |
| Minimal repository icon integration | Read the repository introduction in either theme | 04 实际页面观察；07 复核证据 | 全部已发布 |
| Browser preview uses the shared favicon | Open a real Markdown preview | 02 交付 ICO；05 完成真实 CLI 标签场景；07 复核内置工具入口 | 全部已发布 |
| Preview footer identifies MDGrip without changing attribution records | Display the updated footer under the existing condition；Preserve the existing hidden footer behavior | 06 完成两个页面场景与归属记录保留；07 跨入口复核 | 全部已发布 |
| Editable MIT-licensed asset delivery | Maintain the visual assets；Build without graphics export tools | 02 完成源文件、导出与维护说明；03/05 构建消费贡献；07 完成构建依赖及交付复核 | 全部已发布 |
| Acceptance observes actual integrated surfaces | Record final integration evidence | 03/04/05/06 各自记录即时真实证据；07 完成集成验收记录 | 全部已发布 |

票据 06 无图标依赖，可以在单独获准后独立实施；03、04、05 仅依赖共享成品资产，不互相串行阻塞。票据编号与整体审阅顺序不改变这些真实依赖。

## Closure record

交付物（verification-only，无产品代码改动）：`../reviews/packaged-acceptance/`（README.md 验收记录 + 12 张证据图；其中 04/05 为同日以 `macos/.build/MDGrip-arm64.xcarchive` 重装的同一 arm64 候选复观察重拍并按隐私卫生裁剪/虚化，10/12 内缩去除底窗边缘，其余为本票原始观察）。任务 4.1、4.2 由本票唯一承担，全部实现态验收标准已在本机实际观察/结构检查覆盖，复选框已勾。

实测（详见 `../reviews/packaged-acceptance/README.md`）：`make macos-candidate` 双架构 archive 均 `** ARCHIVE SUCCEEDED **`，`macos-candidate-check` 双双 `candidate checks passed`（strict 签名、精确标识符、adhoc、单架构 slice）；`/Applications` 安装 arm64 DMG 载荷后块根观察：Finder/应用程序目录彩色蓝 tile 图标（01/02）、深色菜单栏白色 template“叠窗”（03，AppleScript description=`MDGrip`）、点按开/关原面板（04/05）、运行中 Dock 无图块（`lsappinfo type="UIElement"` ×2 + `06`）；两枚 DMG 只读挂载结构检查：双架构 `Assets.car`(136 552 B 相同 SHA-256)+`AppIcon.icns`(19 386 B)+`CFBundleIconName=AppIcon`，AppIcon rendition 16–1024 px 全组、StatusBarIcon 18/36 template；构建入口 `Makefile`/`build-md-grip.sh`/CI/Go 源无任何图像导出引用，`make build` 纯 `go build` 且产二进制字节含交付 ICO 与页脚文案（命令留档）；打包内置工具 `md-grip`（ports 6431/6432，真实 Chrome 一次性 profile）：served ICO 响应体与仓库交付 SHA-256 一致，真实标签显示蓝色“叠窗”favicon（07/10/12），`--bounding-box=true` 页脚原位显示 `Rendered with MDGrip` 无旧文案（08/09），`=false` 页面底部无 footer（11/12）后双服务停止、临时 profile 删除、`/Applications` 副本移除并逐一核实。LICENSE 与 HEAD 一致；README 相对 baseline 仅 +2 行（票 04）；layout.html 仅 −1/+1（票 06）；无新增永久测试。未验证项如实记录：x86_64 实际运行（仅结构检查）、不知软件公证/其他硬件/clean-install、README 远端 GitHub 渲染。

独立审查：Standards 与 Spec 两轴独立并行（scout 复审均可读写盘证据）；初审 Spec PASS（0 blocking / 4 advisory / 3 scope decisions——scope 1–3 与本会话既有授权一致，已按最小合规记录）；初审 Standards PASS（0 blocking / 3 advisory / 1 scope decision）。补救后两轴复审：§2 双架构记录对称 + 字节检查命令留档、§4 安装来源与复观察/虚化披露、无 Dock 断言以 `lsappinfo` 原始输出 + `Info.plist LSUIElement=true` 结构判定承载、§6 浅色栏明确承票 03 开发构建观察——**全改动面 changed-area PASS，残余计数 0 blocking / 0 advisory / 0 未决 scope**。后续文档小修经用户批准，将票 03 的系统版本标签由误记的 macOS 26 纠正为 macOS 27.0.1，未重跑原观察；复观察面板中既有用户偏好 Recent 路径为 bundle 历史状态（已披露）。

变更清单：仅 `reviews/packaged-acceptance/`（README.md + 12 png）。AFTER 补救复审期间未动任何产品文件/兄弟票据/测试；既有与本票无关改动（`AGENTS.md`、`.agents/skills/tasks-to-tickets/SKILL.md`）及票据 02–06 交付原样保留。未 commit、未 sync 主 spec、未归档、未发布新版本。
