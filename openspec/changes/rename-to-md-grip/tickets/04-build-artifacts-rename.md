# 构建产物与候选流水线更名

Status: done
Blocked by: 03
Covers OpenSpec tasks: 2.5
Behavior source: ../specs/macos-app-packaging/spec.md（Candidate DMG and Services-only Finder integration、Per-architecture candidate verification 的命名）
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

构建产物与候选打包流水线名称统一为新品牌：`MDGrip.app`、`MDGrip-<arch>.xcarchive`、`MDGrip-arm64.dmg` / `MDGrip-x86_64.dmg`、candidate 目录布局。用户可见结果：本地构建与候选打包产物全部使用新名，标识符校验按新 bundle ID 与工具 ID。

## Acceptance

- [x] `make macos` 产出 `MDGrip.app`
- [x] `make macos-candidate` 产出 `MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg`
- [x] `make macos-candidate-check` 通过（codesign 严格、`com.showgp.MDGrip`、`com.showgp.MDGrip.md-grip`、ad-hoc、架构互斥）

## Closure record

- 关闭:2026-10-09,状态 `done`。性质:验证型票(verification-only)——Makefile/`build-md-grip.sh` 的产物与路径名替换已由票 03 完成并入库,本票据批准 seam 执行真实流水线验证,未新增/修改任何 tracked 文件、测试或文档(`git status --short -- Makefile macos/Scripts/` 的改动为票 03 遗留,本票零写入;产物均在 gitignore 的 `macos/.build/` 下)。
- 范围外证据(移交票 05/task 3.1):`.github/workflows/build.yml:61-62` 与 `release.yml:107-108` 仍引用 `GoGrip-<arch>.dmg` 路径、artifact 名 `GoGrip-macos-candidate*`;上传路径与实际产物名暂不一致,由票 05 修复(须与新 DMG 名逐字一致)。
- 实测证据(集成状态,本次亲见,21:11–21:13):
  - `make macos-test` → exit 0,xcresult 95 passed / 0 failed / 0 skipped。
  - `make macos` → `** BUILD SUCCEEDED **`,exit 0;`macos/.build/DerivedData/Build/Products/Release/MDGrip.app` 含 `Contents/MacOS/{MDGrip, md-grip}`。(注:该 DerivedData 中 Release 产物复用票 03 冷构建;本次判定依据为 Go 源自 `bfba50e` 无改动 + xcarchive 重新编译验证,见下。)
  - `make macos-candidate` → exit 0;arch 循环首次即以测试态 `DerivedData`(21:12)生成 `macos/.build/MDGrip-{arm64,x86_64}.xcarchive`(**ARCHIVE SUCCEEDED**,两架构均重新编译归档),`macos/.build/candidate/MDGrip-arm64.dmg`(8,085,371 B)与 `MDGrip-x86_64.dmg`(8,875,540 B);check 目标输出 `candidate checks passed` 两行。
  - 独立复核(非仅依赖 check 目标):archive 与 DMG 内副本 `codesign --verify --strict` 均通过;app `Identifier=com.showgp.MDGrip`、工具 `Identifier=com.showgp.MDGrip.md-grip`,均 `Signature=adhoc`、thin 单架构 Mach-O;`lipo -verify_arch` 仅本架构通过、另一架构拒绝;`hdiutil attach` 实挂双 DMG 校验(CRC 通过,含 `MDGrip.app` + `Applications -> /Applications`),DMG 内工具 sha256 与 archive 内逐字节一致(arm64 `4f4d288e…`,x86_64 `609153f95c…`);归档工具内嵌 `github.com/showgp/md-grip`、含 `/__mdgrip/ready` 与 `X-MDGrip-Generation`、旧串 `/__gogrip`/`X-GoGrip` 为 0。
  - grep:`Makefile mise.toml flake.nix macos/Scripts/` 旧名(`GoGrip|go-grip|gogrip`)为空;`make macos-candidate` 的唯一警告为 Xcode `No App Category` 与 `hdiutil` deprecation 提示,均与更名无关。
- 未观察/不在本票范围:CLI 协议冒烟(5.3/票 08)、App 界面冒烟(5.5)、README/docs/workflows(票 05–07)。
- 独立审阅(并行只读子代理 `ReviewStandards04`/`ReviewSpec04`,未复跑构建/挂载):Standards 轴 PASS——0 阻塞/0 新增可行动 advisory/0 未决裁决(D1 一致性、目标链 `macos-candidate`→`macos-dmg`→`macos-archive`→check 一致性、`set -e` 与失败分支、脚本无条件重编译、运行端 `AppDelegate.swift:20-22` 路径一致、无 shim/防御抽象/超出范围测试、无 changelog 义务);Spec 轴 PASS——0 阻塞/0 未决裁决(逐项核对 delta 规格命名与校验条款、无 universal DMG/zip、bundle/工具 ID 未变、task 2.5 输出标准在集成态满足)。两轴 advisory(非阻塞、非本票引入):`macos-candidate-check` 仅校验 archive 未挂载 DMG 本体(早于本票的既有行为,DMG 本体证据由本次实挂复核补足);工作流旧路径属票 05。覆盖限制:两轴均未复跑构建/测试/挂载/codesign,未 witness 全部运行时证据;本票无提交、无干净固定点,按清单与直接文件检查。
- 账本核对:task 2.5 输出标准(`make macos` 产出 `MDGrip.app`、`make macos-candidate` 产出双 DMG)已在集成状态观察 → 勾选;artifact 名与 check 目标为 2.5 的完整实现面,票 05 的 workflow 路径更新是下游消费方对齐(3.1 自身责任),非 2.5 验证贡献者。`openspec instructions apply` 复核 20 项 / 9 完成,与文件一致。未执行:提交、主规格同步、归档、下一票。
