# macOS 工程与 App 更名

Status: done
Blocked by: 02
Covers OpenSpec tasks: 2.1, 2.2, 2.3, 2.4
Behavior source: ../specs/macos-finder-service/spec.md（Finder Services entry 的服务命令名）
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

macOS 工程整体改名为 MDGrip：源码目录、测试目录、工程目录、scheme、构建脚本 `git mv`；pbxproj 的 target 名、`PRODUCT_NAME`、`PRODUCT_BUNDLE_IDENTIFIER`（`com.showgp.MDGrip` 与 `.MDGripTests`）、路径与 build phase 名；`Info.plist` 的 `NSPortName` 与 NSServices（`NSMessage` 改 `openWithMDGrip`）；en/zh 本地化串、菜单栏无障碍描述、警示文案统一为 MDGrip；UserDefaults 键改为 `md-grip-recent-targets-v1` / `md-grip-first-use-guidance-shown`，并按 design D3 清理 `RecentTargetsStore` 注释中的遗留键叙述（无迁移分支）。

## Acceptance

- [x] `xcodebuild -list -project macos/MDGrip.xcodeproj` 显示 `MDGrip` 与 `MDGripTests` target 及 `MDGrip` scheme
- [x] `make macos-test` 全绿
- [x] strings 文件含 “Open with MDGrip” / “用 MDGrip 打开”；`macos/` 目录内旧串 grep 为空

## Closure record

- 关闭:2026-10-09,状态 `done`。用户批准:本票范围、验证 seams(现有 `make macos-test` 套件 + `xcodebuild -list` + grep 清单;不新增测试)与范围裁决——Makefile 全量替换并入本票(选项 A:交付后 `make macos`/`macos-run`/`macos-archive` 等目标保持可用;task 2.5 的“替换”由本票吸收,其验证归票 04)、`go-grip-history` 测试固件改中性键 `unrelated-preference`(断言不增删,仅机械改写)。执行许可:实现本票;不提交、不续票、不同步主规格、不归档。
- 变更面(本票,35 个 `git mv` + Makefile 修改;无新增/未跟踪文件;与票 01/02 未提交改动同树,无干净 git 固定点):改名 `macos/GoGrip`→`macos/MDGrip`(21 文件)、`macos/GoGripTests`→`macos/MDGripTests`(10)、`macos/GoGrip.xcodeproj`→`macos/MDGrip.xcodeproj`(3)、scheme→`MDGrip.xcscheme`、`GoGripApp.swift`→`MDGripApp.swift`、`Scripts/build-go-grip.sh`→`build-md-grip.sh`;内容替换 `project.pbxproj`(40 处)、scheme(12 处)、`Info.plist`(`openWithMDGrip`/`NSPortName`/菜单文案)、en/zh `Localizable.strings`+`ServicesMenu.strings`、Swift 源码(`AppDelegate` 工具加载路径 `Contents/MacOS/md-grip` 与 a11y、`MDGripMain`、`FinderServiceProvider.openWithMDGrip`、`PopoverView`、`AppAlertPresenter`、`PreviewSessionCoordinator`、两 store 键与 D3 注释)、8 个测试文件(suite 名/固件路径/消息机械改写)、构建脚本(产物 `md-grip`、签名 ID `com.showgp.MDGrip.md-grip`)、Makefile 全量(project/scheme 路径、test staging、`MDGrip.app`/`MDGrip-<arch>.xcarchive`/`MDGrip-<arch>.dmg`、签名校验 ID)。披露修复:删除 `FirstUseGuidanceStoreTests`/`RecentTargetsTests` 两行失效 `@testable import`——测试 target 为逻辑 bundle、直接编译 app 源码(pbxproj Sources 阶段,无 app 依赖),该 import 此前仅靠 stale DerivedData 中旧 module 解析,改名后冷构建报 `Unable to resolve module dependency: 'MDGrip'`。无新增测试、无行为变更、无迁移分支、无兼容层。
- 实测证据(集成状态,本次亲见):
  - `xcodebuild -list -project macos/MDGrip.xcodeproj` → Targets `MDGrip`、`MDGripTests`;Schemes `MDGrip`。
  - 先 `make macos-clean`(清掉改名前的陈旧构建缓存:旧 `GoGrip-*.xcarchive` 与 DerivedData 产物,577 个旧串文件),再冷构建:`make macos-test` → `** TEST SUCCEEDED **`,exit 0,xcresult 95 passed / 0 failed / 0 skipped(含真实 Go 子进程 `ManagedProcessGoIntegrationTests`);`make macos` → `** BUILD SUCCEEDED **`,产出 Release `MDGrip.app`,`Contents/MacOS/{MDGrip, md-grip}`;codesign 实测 app `Identifier=com.showgp.MDGrip`、内置工具 `Identifier=com.showgp.MDGrip.md-grip`,均 ad-hoc;重建后 `macos/.build` 旧串文件 0。
  - grep:字面 `grep -rniE 'go-?grip' macos Makefile`(仅排除 `.DS_Store`)为空;`grep -c 'GoGrip\|go-grip' project.pbxproj` = 0;旧 UserDefaults 三键在 macos/ 为空;strings 含 “Open with MDGrip”(Info.plist + en/zh ServicesMenu)与 “用 MDGrip 打开”。
  - 未观察:`make macos-candidate`/`macos-candidate-check` 与双 DMG(票 04)、App 界面冒烟(5.5/票 08)、docs/README/workflows(票 05–07)。
- 独立审阅(并行只读子代理 `ReviewStandards`/`ReviewSpec`,未复跑实现者检查):Standards 轴 PASS——0 阻塞/0 advisory/0 未决裁决(核验 D1 一致性:pbxproj/scheme/Info.plist/Swift 串/本地化键逐字匹配、Services selector 与注册、Makefile 全目标与产物/签名一致、脚本与 AppDelegate 路径一致、测试断言数不变与 import 删除正当、D3 清理;YAGNI 无未追踪新增);Spec 轴 PASS——0 阻塞/0 advisory/0 未决裁决(两份 delta + 四份主规格逐项核对:Services 命令名、bundle/工具 ID、DMG 名、UserDefaults 键无迁移均属批准范围;主规格旧文本属归档前同步,非本票矛盾)。审阅覆盖限制:两轴均未重跑构建/测试/冒烟、未独立见证执行;无干净固定点,按提供清单与直接文件检查;未验证运行时 Finder 注册/冷启动/本地化选择/候选 DMG 实包。
- 账本核对:任务 2.1–2.4 整项验证标准已在集成状态观察 → 四项勾选;任务 2.5 保持未勾——`make macos` 半项已见,`make macos-candidate` 产出双 DMG 属票 04(`Blocked by: 03`)剩余贡献者。`openspec instructions apply` 复核 20 项 / 8 完成,与文件一致。未执行:提交、主规格同步、归档、下一票。
