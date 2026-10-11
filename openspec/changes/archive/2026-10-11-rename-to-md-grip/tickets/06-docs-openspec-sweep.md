# docs 与 openspec 全量 sweep

Status: done
Blocked by: 04
Covers OpenSpec tasks: 4.1
Behavior source: None（叙述性文本，无需求级变更）
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

全部叙述性文本换用新名：`docs/`（ARCHITECTURE、HANDOVER、macos-app-* 计划/实施文档、`adr/0001`–`0004`、`agents/*`）与 `openspec/`（`specs/`、`changes/archive/` 全部）中描述本仓库自身工具、产物、命令处一律为 md-grip / MDGrip；对上游项目的引用保持 `chrishrb/go-grip` 原名。

## Acceptance

- [x] `grep -ri 'gogrip' docs openspec` 的命中仅剩票 08 定义的允许两类
- [x] 抽查 ADR-0002/0004 与 ARCHITECTURE 的命令/产物名与 Makefile 实际产物一致

## Closure record

- 关闭:2026-10-09,状态 `done`。性质:叙述性文本 sweep(无代码、无测试、无行为变更)。无 Git 固定点(工作树含前序票未提交改动);本票基线为 HEAD `bfba50e` 的 `docs/`+`openspec/` 洁净状态(改前 `git status --short -- docs openspec` 仅列未跟踪的 change 工件),故 `git diff -- docs openspec`(2585 行)即本票完整变更面。
- 用户批准与本票范围裁决(2026-10-09,实施前):范围=全部 `docs/` 与 `openspec/`(含 `specs/` 与 `changes/archive/` 全量),不含 `openspec/changes/rename-to-md-grip/`(票 08 允许类 b);机械规则=`保护 chrishrb/go-grip` → `GoGrip→MDGrip` → `gogrip→mdgrip` → `go-grip→md-grip` → `还原上游 slug`;裁决一:旧 UserDefaults 键 `go-grip-history` 一并改名 `md-grip-history`(26 处历史/证据行,明知不改写历史保真,依用户明示裁决);裁决二:历史证据路径文本(`~/GoGrip-acceptance-13`、`/tmp/gogrip-*`、`Test-GoGrip-*`、`/Volumes/GoGrip*` 等)随 sweep 机械改名,仅动文档文本、不动磁盘。执行许可:实现本票;不提交、不续票、不同步主规格、不归档。
- 变更面(本票,44 文件,453 insertions/453 deletions,无新增/未跟踪文件):`docs/` 17(ARCHITECTURE、HANDOVER、REVIEW、engineering-status、implementation-plan、hot-reload-fix-plan、macos-app-plan/impl、editing-*×6、adr/0001、0003、0004;adr/0002 与 `agents/*` 无命中未动);`openspec/specs/` 2(macos-app-packaging、macos-finder-service,仅正文字符串);`openspec/changes/archive/` 25(rebuild-macos-preview-app 18、split-candidate-dmg-by-arch 7)。无其它 tracked 文件改动。
- 实测证据(本次亲见):
  - s1(验收 1):`grep -rni 'gogrip' docs openspec | grep -v <change dir>` = 0;剩余命中全部位于 `openspec/changes/rename-to-md-grip/`(类 b:映射表/原文引用,票 08 允许)。
  - s2(残留分类):`grep -rniE 'go-?grip' docs openspec | grep -v <change dir>` 仅 2 行——`docs/ARCHITECTURE.md:15` 与 `docs/engineering-status.md:7`,均为 `chrishrb/go-grip` 上游引用(类 a)。
  - s3(机械性证明):44 文件逐一 `git show HEAD:<f> | sed -E '<五步程序>' | diff - <f>` 全部逐字节一致 → 纯机械替换,无结构/格式破坏;`@@UPSTREAM@@` 哨兵残留为 0。
  - s4(验收 2 抽查):ARCHITECTURE §十六 与 ADR-0004 的 `bin/md-grip`、`macos/.build/MDGrip-<arch>.xcarchive`、`MDGrip-arm64.dmg`/`MDGrip-x86_64.dmg`、`MDGrip.app/Contents/MacOS/md-grip`、`macos/Scripts/build-md-grip.sh`、`com.showgp.MDGrip`/`com.showgp.MDGrip.md-grip` 与 Makefile:4,42,44,58,74-78 及构建脚本逐字一致;ADR-0002 无旧名且 0 diff。
  - s5:`openspec validate --all` → 5 passed / 0 failed(4 主规格 + 1 change);`openspec status --change rename-to-md-grip` 与改前一致。
- 已知披露(机械规则结果,非阻塞):`docs/HANDOVER.md:159` 的本机 checkout 绝对路径随 `go-grip→md-grip` 改名(仓库目录改名属运维步骤/非目标,文本先行);历史证据路径与键名(裁决一/二)同理——docs/openspec 文本已无旧名,磁盘实体未动。
- 独立审阅(并行只读子代理 `ReviewStandards06`/`ReviewSpec06`,未复跑实现者检查、未改文件):Standards 轴 PASS—0 阻塞/0 advisory/0 未决裁决(通读完整 2585 行 diff 与 44 文件清单;D1 一致性、无结构破损、无范围蔓延;历史/移除路径的机械改名判定为批准范围内);Spec 轴 PASS—0 阻塞/0 advisory/0 未决裁决(逐条核对类 a/b 清单、主规格结构未变、delta 语义未预占、ADR/ARCHITECTURE 与 Makefile 逐字一致;本票无行为 delta,按批准的非行为范围审阅)。覆盖限制:两轴均未复跑 s3/s5,未做构建/运行/行为验证;本票无行为面。
- 账本核对:task 4.1 输出标准(`grep -ri 'gogrip' docs openspec` 命中仅剩 5.1 允许两类)已在集成状态观察 → 勾选(4.1 无其它贡献者;4.2–4.4 属票 07,保持未勾)。`openspec instructions apply` 复核 20 项 / 11 完成,与文件一致。未执行:提交、主规格同步、归档、下一票。
