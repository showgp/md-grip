# Tasks

## 1. Go 侧更名

- [x] 1.1 `go.mod` module path 改为 `github.com/showgp/md-grip`，并更新全部 Go import（`main.go`、`cmd/`、`internal/`、`pkg/`）；验证：`go build ./...` 通过，`grep -r 'showgp/go-grip' --include='*.go'` 为空
- [x] 1.2 CLI 命令与二进制名更名：`cmd/root.go` 的 `Use "go-grip [file]"` 改 `md-grip [file]`，Makefile、mise.toml、flake.nix 中 `bin/go-grip*` 等构建产物名按 design D1 表同步；验证：`go run . --help` 头部显示 `md-grip`，`make build` 产出 `bin/md-grip*`
- [x] 1.3 受管协议标识符两端同步更名：`internal/managed.go` 的 `managedReadyPath` `/__gogrip/ready` → `/__mdgrip/ready`、`managedGenerationHeader` `X-GoGrip-Generation` → `X-MDGrip-Generation`，`macos/GoGrip/Services/ManagedProcess.swift` 客户端侧同 commit 修改；验证：两文件旧串 grep 为空（App 侧行为证据由 5.3/5.5 给出）
- [x] 1.4 Go 代码与测试中其余 `go-grip`/`gogrip` 字符串（含测试临时路径等）按 D1 表替换；验证：`grep -ri 'gogrip' cmd internal pkg main.go go.mod` 为空，`go test ./...` 通过

## 2. macOS App 侧更名

- [x] 2.1 `git mv` 目录与文件：`macos/GoGrip` → `macos/MDGrip`、`macos/GoGripTests` → `macos/MDGripTests`、`macos/GoGrip.xcodeproj` → `macos/MDGrip.xcodeproj`、scheme `GoGrip.xcscheme` → `MDGrip.xcscheme`、`macos/Scripts/build-go-grip.sh` → `build-md-grip.sh`；验证：`xcodebuild -list -project macos/MDGrip.xcodeproj` 显示 `MDGrip` 与 `MDGripTests` target 及 `MDGrip` scheme
- [x] 2.2 `project.pbxproj`（40 处）与 scheme、构建脚本内容按 D1 表替换（`PRODUCT_NAME`、`PRODUCT_BUNDLE_IDENTIFIER` `com.showgp.MDGrip` 与 `.MDGripTests`、受管工具签名 ID `com.showgp.MDGrip.md-grip`、路径与 phase 名）；验证：`xcodebuild -list` 正常，`grep -c 'GoGrip\|go-grip' macos/MDGrip.xcodeproj/project.pbxproj` 为 0
- [x] 2.3 `macos/MDGrip/Info.plist`（`NSPortName`、NSServices 的 `NSMessage` `openWithGoGrip` → `openWithMDGrip` 及菜单文案）与 `en.lproj`/`zh-Hans.lproj` 的 `Localizable.strings`、`ServicesMenu.strings`、`AppDelegate` 无障碍描述、`AppAlertPresenter` 文案统一为 `MDGrip`；验证：strings 含 “Open with MDGrip”/“用 MDGrip 打开”，`grep -ri 'gogrip' macos/MDGrip macos/MDGripTests macos/Scripts` 为空
- [x] 2.4 UserDefaults 键更名：`RecentTargetsStore.defaultKey` → `md-grip-recent-targets-v1`、`FirstUseGuidanceStore` 键 → `md-grip-first-use-guidance-shown`，并按 design D3 删除 `RecentTargetsStore` 注释中 `go-grip-history` 遗留叙述（无迁移分支可写）；验证：`make macos-test` 全绿，`grep -rn 'go-grip-recent-targets-v1\|go-grip-first-use-guidance-shown\|go-grip-history' macos/` 为空
- [x] 2.5 `macos/Scripts/build-md-grip.sh` 与 Makefile 中产物/路径名替换（`GoGrip.app` → `MDGrip.app`、`GoGrip-<arch>.xcarchive` → `MDGrip-<arch>.xcarchive`、`/tmp/gogrip-managed-test-tool` → `/tmp/mdgrip-managed-test-tool` 等）；验证：`make macos` 产出 `MDGrip.app`，`make macos-candidate` 产出 `MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg`

## 3. Release 流水线

- [x] 3.1 `.github/workflows/release.yml` 与 `build.yml` 产物名与路径替换：CLI 归档 `md-grip_<ver>_<os>_<arch>`、artifact `MDGrip-macos-candidate(-<ref>)`、DMG 路径 `MDGrip-<arch>.dmg`；验证：`actionlint`（如可用）或 `yamllint` 通过，path 文件名与 2.5 产物逐字一致
- [ ] 3.2 `release.yml` 新增 Release 附挂步骤：`MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg` 附挂到 GitHub Release，校验和文件重建为覆盖 CLI 归档与双 DMG 全部 assets，发布说明模板含 ad-hoc 签名/未公证声明（规格 `Releases publish per-architecture DMG assets`）；验证：workflow 审查通过，声明文案与 spec delta 场景一致（assets 实际形态由 v0.14.0 tag 发布时的运维步骤核对）

## 4. 文档、许可与品牌文本

- [x] 4.1 `docs/`（ARCHITECTURE、HANDOVER、macos-app-*、`adr/0001`–`0004`、`agents/*`）与 `openspec/`（`specs/`、`changes/archive/` 全部）文本按 D1 表替换（描述本仓库自身工具/产物处一律新名）；验证：`grep -ri 'gogrip' docs openspec` 的命中仅剩 5.1 允许的两类
- [x] 4.2 README 重写：App 优先叙事、纯文字标题（删除 upstream logo 引用并删除 `.github/docs/logo-1.png`）、“Independent project” 与 lineage 段（声明源于 chrishrb/go-grip fork、MIT 保留其版权、不回提 PR）、仅英文；验证：README 对上游的引用仅以 `chrishrb/go-grip` 形式出现且使用代码体，无 logo 残留
- [x] 4.3 LICENSE 重写：`Copyright (c) 2026 showgp` 在前、`Copyright (c) 2024 Christoph Herb` 保留，附 derived-from 注（指向 chrishrb/go-grip）与 vendored 前端资产许可注（marked/mermaid MIT、MathJax Apache-2.0，声明以文件内头为准）；验证：两行版权在位、两条注记完整
- [x] 4.4 仓库根与其余文件残余清理（`AGENTS.md`、`CONTEXT.md`、`.github/` 其余文件等按 grep 结果处理）；验证：与 5.1 联合核对命中清单

## 5. 端到端验证

- [x] 5.1 全仓验收 grep：`grep -ri 'gogrip' . --exclude-dir=.git` 的命中仅允许两类——(a) 对上游项目 `chrishrb/go-grip` 的引用（README lineage 段、LICENSE 来源注），(b) `openspec/changes/rename-to-md-grip/` 自身工件中的映射表与原文引用；验证：命中清单逐条人工核对属于 (a) 或 (b)，其余为零
- [x] 5.2 Go 全量检查：`go build ./... && go vet ./... && go test ./...`；验证：三者全部通过
- [x] 5.3 CLI 冒烟：构建 `md-grip` 后对临时目录启动，`curl -I http://127.0.0.1:<port>/__mdgrip/ready` 返回且带 `X-MDGrip-Generation`，浏览器渲染目录预览正常；验证：观察到响应头与渲染页面
- [x] 5.4 macOS 全量：`make macos-test`、`make macos`、`make macos-candidate && make macos-candidate-check`（codesign 严格校验、Bundle ID `com.showgp.MDGrip`、工具 ID `com.showgp.MDGrip.md-grip`、ad-hoc、架构互斥校验）；验证：全部通过
- [x] 5.5 App 真实界面冒烟：启动 `MDGrip.app`，观察菜单栏出现、“Open with MDGrip” 服务可用、首用引导显示、打开目标后最近目标持久化于新 domain；验证：实际观察结果记录于任务备注
