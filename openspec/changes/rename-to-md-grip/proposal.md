# Proposal

## Why

本仓库由 chrishrb/go-grip fork 而来，现已发展为上游不具备的 macOS 优先产品（菜单栏 App、Finder Services、受管预览会话），且 README 已声明不向上游提交 PR。继续沿用 go-grip 名称会让项目归属与产品范围产生混淆：独立命名 md-grip 让名字直接描述功能（Markdown 预览），由 owner 命名空间（showgp）承载作者身份。同时，当前发布流水线将两个候选 DMG 仅作为 workflow artifact 上传，与 App 优先的定位不符：正式 Release 应当直接交付可安装的 App 包。

## What Changes

- 全仓库更名（go-grip → md-grip、GoGrip → MDGrip）：Go module path、CLI 二进制与命令名、release 产物命名、构建脚本、Makefile、mise、flake、CI workflow、docs 与 openspec 全部文本（含 archive）。验收标准：grep 全仓库 `go-grip|GoGrip|gogrip` 归零。
- macOS App 侧更名：`MDGrip.app`、bundle ID `com.showgp.MDGrip`（含 `.MDGripTests`）、受管工具签名 ID `com.showgp.MDGrip.md-grip`、ready 路径 `/__mdgrip/ready`、协议头 `X-MDGrip-Generation`、GCD queue labels、UserDefaults 键；用户可见串 "Open with MDGrip" / “用 MDGrip 打开”。
- **BREAKING** Release 内容变更：release workflow 在 CLI 归档与 checksums 之外新增附挂 `MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg`；“候选包仅 artifact、不进正式发布”的边界条款同步修订。CLI 二进制改名与 module path 变更使既有安装脚本与 `go install` 引用失效。
- 删除因 UserDefaults domain 更名而失效的遗留键忽略逻辑（`go-grip-history`）：无迁移层。
- README 重写为 App 优先叙事（英文、纯文字过渡标题、更名与 lineage 说明段）；LICENSE 增补 `Copyright (c) 2026 showgp` 并保留 `Copyright (c) 2024 Christoph Herb`，附 vendored 前端资产许可说明。

## Capabilities

### New Capabilities

无——本变更不引入新能力。

### Modified Capabilities

- `macos-app-packaging`：候选 DMG 文件名、Bundle ID、内置工具 ID 等命名随 App 更名；新增 “Release 附挂 per-arch DMG 与 checksums” 要求，原 “候选仅 artifact、不表述为正式发布” 边界条款相应修订（未公证状态不变）。
- `macos-finder-service`：Services 命令名与能力描述随 App 显示名更名（“用 GoGrip 打开” → “用 MDGrip 打开”）。

说明：`macos-menu-bar-app` 与 `macos-preview-sessions` 的规格文本不含旧名，无需求级变更；CLI 命名与内部协议标识不在既有 spec 需求范围内，由任务清单承载。

## Non-goals

- 不做品牌设计资产（logo、AppIcon catalog、menu bar 图标）——独立后续阶段。
- 不改变任何渲染、目录浏览、热重载、会话管理的运行时行为；除删除上述死代码外不动逻辑。
- 不做已安装用户的 App 状态迁移（当前无外部用户；旧 UserDefaults domain 随旧安装弃置）。
- 不处理 git 历史重写、GitHub 仓库改名与 fork 网络脱离——属仓库运维步骤，不在代码变更范围。
- 不向上游提交 PR；不升级 vendored 前端资产版本。
