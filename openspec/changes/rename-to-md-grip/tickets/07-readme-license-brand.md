# README、LICENSE 与品牌文本

Status: done
Blocked by: 04
Covers OpenSpec tasks: 4.2, 4.3, 4.4
Behavior source: None（仓库门面文本，无需求级变更）
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

项目门面文本：README 重写为 App 优先叙事——纯文字标题、删除 upstream logo 引用并删除 `.github/docs/logo-1.png`、仅英文、“Independent project” 段与 lineage 段（声明源于 chrishrb/go-grip 的 fork、MIT 保留其版权、不回提 PR）；LICENSE 增补 `Copyright (c) 2026 showgp`（在前）并保留 `Copyright (c) 2024 Christoph Herb`，附 derived-from 注与 vendored 前端资产许可注（marked/mermaid MIT、MathJax Apache-2.0，以文件内头为准）。

## Acceptance

- [x] README 无 logo 引用与资产残留，lineage 段仅以 `chrishrb/go-grip` 代码体引用上游
- [x] LICENSE 两行版权在位、两条注记完整
- [x] 仓库根与其余文件（AGENTS.md、CONTEXT.md 等）经 grep 核对无旧名残留（与票 08 联合验收）

## Closure record

- 关闭:2026-10-09,状态 `done`。性质:门面文本票(README 重写、LICENSE 扩注、仓库根与其余文件残余清理);无运行时行为、无测试、无新增文件。无干净 Git 固定点;README.md / LICENSE / CONTEXT.md / .scratch 在 HEAD `bfba50e` 及前序票均未被触碰,故 `git diff HEAD -- README.md LICENSE CONTEXT.md .scratch` 即本票精确变更面。
- 实施前用户批准(2026-10-09):范围含 `.scratch/macos-platform-v1/**` 10 文件 42× `GoGrip`→`MDGrip` 机械改名(沿用票 06 历史文本先例);README 保留引用的 zh-Hans 服务名“用 MDGrip 打开”(正文全英文);计划含 Releasing 段对齐票 05 后的现实(双 DMG 附挂 Release、checksums 覆盖全部 assets)。
- 变更面(13 修改 + 1 删除,无新增文件):`README.md` 全量重写(App 优先叙事、`# md-grip` 纯文字标题、删除 logo 块、新增 Independent project + lineage 段、全量 D1 改名、Releasing 更新、独立 project 段声明 fork/MIT 保留/不回提 PR);`LICENSE` 增 `Copyright (c) 2026 showgp`(在前)并保留 `2024 Christoph Herb`,MIT 正文逐字未动,追加 derived-from 与 vendored 资产(以文件内头为准)两注;`CONTEXT.md` 4×、`.scratch/macos-platform-v1/spec.md` + 9 issues 42× 纯机械 `GoGrip`→`MDGrip`;删除 `.github/docs/logo-1.png`(`git rm`);`example-1.png` 保留(README Examples 仍引用)。AGENTS.md 与 `.github/` 其余文件经 grep 无命中,未动。
- 实测证据(本次亲见):
  - s1/s3:`grep -ri 'gogrip' README.md LICENSE CONTEXT.md .scratch/` 为空;README 无 `logo-1` 引用;README 中 `go-grip` 仅出现在 `chrishrb/go-grip` 上下文且 5/5 均为代码体。
  - s2(5.1 字面命令):`grep -ri 'gogrip' . --exclude-dir=.git` 命中全部位于 `openspec/changes/rename-to-md-grip/`(类 b);类 a 上游引用不匹配该 pattern;gitignore 产物(bin/、macos/.build/)对该 pattern 0 命中。
  - s4:LICENSE 第 3/4 行为两行版权(showgp 在前),第 26/28 行为 derived-from 与 vendored 两注。
  - s5 渲染冒烟:`make build` 重建 `bin/md-grip` → 以 `-b=false --json` 对 README 启动并拉取页面:唯一 `<h1>md-grip</h1>`;`logo-1` 0 次、`example-1` 1 次、"Open with MDGrip" 4 次、`gogrip`(不分大小写)0 次;TOC 锚点在同渲染器全部可解析,唯一差异为既有 `:twisted_rightwards_arrows:` 下划线/连字符渲染差异(GitHub 保留下划线;原 README 同款,非本票引入)。
  - 机械性证明:11 个机械改名文件逐一 `git show HEAD:<f> | sed 's/GoGrip/MDGrip/g' | diff - <f>` 全部为空。
- 独立审阅(并行只读子代理 `ReviewStandards07`/`ReviewSpec07`,未改文件、未复跑实现者检查):Standards 轴 PASS——0 阻塞/0 新增 advisory/0 未决裁决(事实逐字保留核对、Makefile/构建脚本/release.yml 逐字一致、MIT 未动、logo 无悬空引用、机械改名无附带修改、无新增测试、无 YAGNI 越界);Spec 轴 PASS——0 阻塞/0 advisory/0 未决裁决(lineage/许可事实、DMG 附挂与未公证表述与两 delta 一致、D1/D3 符合、无未批准行为)。覆盖限制:两轴均未复跑构建/冒烟,未观察 GitHub Release 实发、外部 URL 解析与真机界面;审阅限于本票固定点面。
- 披露(非本票缺陷,均属既定非目标/运维步骤):构建产物(`bin/md-grip`、`macos/.build/**`)调试信息内嵌本机 checkout 路径 `/Volumes/.../go-grip/...`(仓库目录改名属运维步骤);渲染页面中 `#46` 类 gh-issue 链接经 `pkg/ghissue` 读取本机 git remote(`git@github.com:showgp/go-grip.git`)生成,GitHub 仓库改名属运维步骤。
- 账本核对:task 4.2(`chrishrb/go-grip` 代码体引用、无 logo 残留)、4.3(两行版权、两注)、4.4(与 5.1 联合核对命中清单——已按 5.1 字面命令在集成状态观察,票 08 将以同一 5.1 门复跑)均 → 勾选;4.2–4.4 无其它贡献者。`openspec instructions apply` 复核 20 项 / 14 完成,与文件一致。
- 未执行:提交、主规格同步、归档、下一票。
