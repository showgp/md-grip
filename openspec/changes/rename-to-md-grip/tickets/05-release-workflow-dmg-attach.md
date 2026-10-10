# Release 工作流更名与 DMG 附挂

Status: done
Blocked by: 04
Covers OpenSpec tasks: 3.1, 3.2
Behavior source: ../specs/macos-app-packaging/spec.md（CI uploads split candidate artifacts、Explicitly deferred formal distribution、Releases publish per-architecture DMG assets）
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

CI/Release 工作流产物名与新名一致：CLI 归档 `md-grip_<version>_<os>_<arch>`、workflow artifact `MDGrip-macos-candidate(-<ref>)`、DMG 路径。release 工作流向 GitHub Release 附挂 `MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg`，校验和文件重建为覆盖 CLI 归档与双 DMG 全部 assets，发布说明含 ad-hoc 签名/未公证声明。

移交自票 04（实际产物名已由 2.5 确定）：`.github/workflows/build.yml:61-62` 与 `release.yml:107-108` 现引用 `macos/.build/candidate/GoGrip-arm64.dmg` / `GoGrip-x86_64.dmg`，artifact 名 `GoGrip-macos-candidate(-ref)`；须逐字改为 `MDGrip-<arch>.dmg` 与 `MDGrip-macos-candidate(-<ref>)`，与 `Makefile:macos-dmg` 产出对齐。

## Acceptance

- [x] workflow lint 通过（actionlint/yamllint，如可用）
- [x] 附挂步骤与 checksums 覆盖范围审查通过，声明文案与 spec delta 场景一致
- [ ] assets 实际形态由 v0.14.0 发布时的运维步骤核对（本票交付工作流变更本身）

## Closure record

- 关闭:2026-10-09,状态 `done`。性质:工作流变更票(非验证-only)。无 Git 固定点,变更面按实际文件与编辑历史核对。
- 变更面(唯一两处):`.github/workflows/build.yml`(artifact `MDGrip-macos-candidate`、DMG 路径 `macos/.build/candidate/MDGrip-<arch>.dmg`)、`.github/workflows/release.yml`(重构为三 job:`build-cli-archives` 产出 `md-grip_<ver>_<os>_<arch>` 归档并上传 artifact `cli-archives`;`build-macos-app` 保持 macos-test/candidate 并上传 `MDGrip-macos-candidate-<ref>`;新 `publish-release` 下载双 artifact 入 `dist/` → `sha256sum * > checksums.txt` → `softprops/action-gh-release@v3` `files: dist/*` + 未公证声明 body)。无其他 tracked 文件改动,无新增文件;冒烟用 `dist/` 与 /tmp 脚本已清理。
- 实施前用户批准的决策:三 job 结构;`action-gh-release` @v2→@v3(依据:v2 上游自陈 final v2 未维护、声明 `runs.using: node20`);发布说明英文;其余 action pin 不动(仓库级 node20 现代化属另行变更)。
- 实测证据(本次亲见):
  - actionlint 1.7.12(`mise x actionlint@latest`):`Found 0 errors in 2 files`,verbose 确认两文件均被 lint;`shellcheck`/`pyflakes` 规则因未安装被自动禁用(`run:` 脚本未经 shellcheck)。
  - `grep -rni 'gogrip\|go-grip' .github/` 无命中(exit 1);workflow 内 DMG 路径与 `Makefile:36,58` 产物逐字一致;上传/下载 artifact 名对称;checksums 步骤覆盖 `dist/` 全部 8 个 payload。
  - 本地执行冒烟(一次性,经 Ruby 从 YAML 逐字提取 `run:` 后以 /bin/bash 执行):归档步骤 exit 0,产出 `md-grip_test_<os>_<arch>.{tar.gz,zip}` ×6,tar/zip 内含 `md-grip`/`md-grip.exe` + LICENSE + README.md;checksum 步骤(sha256sum→shasum shim)在全新 `dist/`(6 归档 + 2 假 DMG)产出恰 8 行、无 checksums.txt 自包含,`shasum -a 256 -c` 8/8 OK。
  - YAML 结构核对(psych 解析):顶层 `contents: write` 由上继承,`build-macos-app` 保持 `contents: read`;`publish-release.needs` = 双构建 job。
  - 发布说明 body 逐字提取核对:标注 candidate、ad-hoc、未公证、干净安装验证未完成、信任流程未验收;无已公证/已验收表述。
- 独立审阅(并行只读子代理 `ReviewStandards05`/`ReviewSpec05`,未复跑实现者检查、未改文件):Standards 轴 PASS——0 阻塞/0 未决裁决,1 条 informational advisory(其余 pin 仍声明 node20,按批准范围留待仓库级另行变更);Spec 轴 PASS——逐条核对 `CI uploads split candidate artifacts`、`Releases publish per-architecture DMG assets`、`Explicitly deferred formal distribution` 场景与发布说明两句,0 阻塞/0 advisory/0 未决裁决。两轴均声明其审查限于 workflow 文本,不构成发布执行验证。
- 覆盖限制/未观察:未执行 GitHub Actions 真跑(需 GitHub runner 与 tag);shellcheck 未安装;v0.14.0 实际 assets 形态未观察。
- 账本核对:task 3.1 输出标准(actionlint 通过、path 与 2.5 产物逐字一致)已在集成态观察 → 勾选;task 3.2 的 workflow 审查与文案一致性已观察,但票面验收第 3 条/task 3.2 括注的"assets 实际形态由 v0.14.0 发布运维核对"在集成态不可观察 → **票面第 3 条与 task 3.2 均保持未勾选、不宣称**,作为 v0.14.0 发布时的运维步骤保留在覆盖计划中。`openspec instructions apply` 复核后 20 项 / 10 完成,与文件一致。
- 未执行:提交、主规格同步、归档、下一票。
