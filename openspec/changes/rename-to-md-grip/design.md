# Design

## Context

仓库当前事实（sweep 的输入）：Go module path `github.com/showgp/go-grip`（7 个 .go 文件 import）；CLI 二进制与 cobra 命令 `go-grip`；macOS App `GoGrip.app`（bundle ID `com.showgp.GoGrip`、受管工具 ID `com.showgp.GoGrip.go-grip`）；受管协议 `/__gogrip/ready` + `X-GoGrip-Generation`（Go 服务端与 Swift 客户端两端）；GCD queue labels `com.showgp.go-grip.managed-*`；UserDefaults 键 `go-grip-recent-targets-v1`、`go-grip-first-use-guidance-shown`；名称字符串出现于 103+ 个 tracked 文件，其中 `project.pbxproj` 40 处、openspec 含 archive 全量。37 个 tag/release 属历史快照，不由本 change 改写。

关键约束：无外部用户（App 无公开分发，CLI 用户可忽略）→ 无兼容层、无迁移代码；App 与内置 CLI 锁版本同发 → 私有协议两端可同 commit 改名；公开工件（proposal/spec/design/tasks、commit message、release notes）只写更名事实，不含动机叙述。

## Goals / Non-Goals

**Goals:**
- 以单一命名映射表（见 Decisions D1）为唯一事实来源完成一次机械 sweep，验收标准可执行且唯一：全仓库 `grep -ri 'gogrip'` 归零 + 构建/测试/冒烟全绿。
- 使规格与现实一致：Release 附挂双 per-arch DMG（`macos-app-packaging` delta 已批）。
- 删除因 domain 更名而失效的遗留键说明性逻辑（见 D3）。

**Non-Goals:**
- 品牌设计资产（logo/AppIcon catalog/menu bar 图标）——后续独立阶段。
- 除规格已批项外的任何运行时行为变更；不升级 vendored 资产。
- git 历史重写、GitHub 仓库改名、fork 网络脱离——运维步骤，另行执行。
- 已安装用户的状态迁移。

## Decisions

**D1. 命名映射表（全 sweep 的替换蓝本）**

| 旧 | 新 |
|---|---|
| `github.com/showgp/go-grip` | `github.com/showgp/md-grip` |
| 二进制/命令 `go-grip` | `md-grip` |
| `GoGrip.app` / 工程目录 `GoGrip.xcodeproj` / 源码目录 `macos/GoGrip`、`macos/GoGripTests` / scheme / `build-go-grip.sh` | `MDGrip.app` / `MDGrip.xcodeproj` / `macos/MDGrip`、`macos/MDGripTests` / `MDGrip.xcscheme` / `build-md-grip.sh` |
| `com.showgp.GoGrip`（+ `.GoGripTests`） | `com.showgp.MDGrip`（+ `.MDGripTests`） |
| `com.showgp.GoGrip.go-grip` | `com.showgp.MDGrip.md-grip` |
| `/__gogrip/ready` / `X-GoGrip-Generation` | `/__mdgrip/ready` / `X-MDGrip-Generation` |
| `com.showgp.go-grip.managed-*` | `com.showgp.md-grip.managed-*` |
| `go-grip-recent-targets-v1` / `go-grip-first-use-guidance-shown` | `md-grip-recent-targets-v1` / `md-grip-first-use-guidance-shown` |
| `go-grip_<ver>_<os>_<arch>` / `GoGrip-<arch>.dmg` / `GoGrip-macos-candidate` | `md-grip_<ver>_<os>_<arch>` / `MDGrip-<arch>.dmg` / `MDGrip-macos-candidate` |
| “Open with GoGrip” / “用 GoGrip 打开” / a11y “GoGrip” | “Open with MDGrip” / “用 MDGrip 打开” / “MDGrip” |

**D2. 替换顺序与工具**：先改 `go.mod` module path → `go build ./...` 立即暴露全部 import 断点 → `sd` 批量替换文本（`gogrip`/`go-grip`/`GoGrip` 三形态，按 D1 核对每个文件）→ `git mv` 文件/目录重命名（工程目录、源码目录、scheme、构建脚本）→ `pbxproj`/`Info.plist`/strings/工作流/Makefile/mise/flake → docs 与 openspec（含 archive）→ README/LICENSE 手写重写。不采用 AST 工具：纯字符串标识符，文本替换即可且更可审查。

**D3. 遗留键处理**：`RecentTargetsStore` 对 `go-grip-history` 的“处理”仅为文档注释（代码从不读写该键）。domain 更名后该注释指向不存在的状态，随 sweep 删除，注释改述当前键；无任何迁移分支需要写。

**D4. Xcode 工程策略**：`pbxproj` 内 40 处引用为一致前缀（目标名、路径、`PRODUCT_*`），整文件文本替换后以 `xcodebuild -list` 核对 target/scheme 名称，`make macos` 产出 `MDGrip.app` 为准。`Info.plist` 的 `NSPortName`/`NSServices` 与 strings 文件由 D1 表覆盖。

**D5. Release 附挂实现**：`release.yml` 在候选 DMG 构建步骤后新增 Release attach：双 DMG + 重建后的 checksums（`sha256sum` 覆盖 CLI 归档与双 DMG 全部 assets）；artifact 名统一 `MDGrip-macos-candidate-<ref>`。发布说明模板含未公证声明（规格 `Releases publish per-architecture DMG assets`）。

**D6. 验收标准（唯一清单）**：
1. `grep -ri 'gogrip' .`（排除 `.git/`）输出为空；
2. `go build ./... && go test ./...` 通过；
3. Swift 测试通过（现有 `make macos-test` 通道）；
4. CLI 冒烟：启动 `md-grip` 后 `curl` `/__mdgrip/ready` 返回且带 `X-MDGrip-Generation`；
5. `make macos` 产出 `MDGrip.app`，candidate 流程产出 `MDGrip-<arch>.dmg`。

## Risks / Trade-offs

- **大小写/变体遗漏**：以 `grep -i 'gogrip'` 归零 + `go build` 双兜底；`-i` 覆盖 `GOGrip`、`gOGrip` 等意外变体。
- **pbxproj 文本替换破坏工程**：替换仅涉一致前缀字符串，`xcodebuild -list` + 完整构建为硬验证；若工程损坏，回退单文件重做。
- **未公证 DMG 面向公众**：用户知情批准（spec delta 已定发布说明强制声明）；无进一步缓解。
- **旧名残留于 GitHub 侧历史（releases 名、issue 引用）**：37 个旧 release 名称属历史快照，不属本 change 验收；新 Release 起全部为新名。
- **文档纪律执行**：本 change 全部公开文本只含更名事实；review 工件时按此检查。
