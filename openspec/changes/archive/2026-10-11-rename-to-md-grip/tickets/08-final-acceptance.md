# 全仓验收与端到端验证

Status: done
Blocked by: 05, 06, 07
Covers OpenSpec tasks: 5.1, 5.2, 5.3, 5.4, 5.5
Behavior source: ../specs/macos-app-packaging/spec.md、../specs/macos-finder-service/spec.md（本票为验证-only，核对已实现行为）
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

更名的总验收门。全仓 grep 验收：`grep -ri 'gogrip' . --exclude-dir=.git` 的命中仅允许两类——(a) 对上游项目 `chrishrb/go-grip` 的引用（README lineage 段、LICENSE 来源注），(b) 本 change 自身工件中的映射表与原文引用；其余必须为零，命中清单逐条人工核对。随后全量验证：Go 三连、CLI 冒烟、macOS 全量、App 真实界面冒烟（启动 MDGrip.app：菜单栏出现、“Open with MDGrip” 服务可用、首用引导显示、打开目标后最近目标持久化于新 UserDefaults domain；界面部分由实现者启动、与用户协同观察）。

## Acceptance

- [x] 全仓 grep 命中清单逐条核对属于 (a) 或 (b)，其余为零
- [x] `go build ./... && go vet ./... && go test ./...` 通过
- [x] CLI 冒烟：`/__mdgrip/ready` 返回且带 `X-MDGrip-Generation`，目录预览渲染正常
- [x] `make macos-test`、`make macos`、`make macos-candidate && make macos-candidate-check` 全绿
- [x] App 真实界面冒烟观察结果记录于本票 Comments

## Comments — 5.5 界面冒烟观察记录（2026-10-09）

用户协同观察（user-reported 视觉证据；系统 locale en_US；对象为 `macos/.build/DerivedData/Build/Products/Release/MDGrip.app`，`Identifier=com.showgp.MDGrip`、ad-hoc）：

- 启动时自动弹出首用引导（标题 “Using MDGrip from Finder”）→ 用户确认看到。
- 菜单栏出现新的 MDGrip 状态项（doc.text 图标），点击弹出 MDGrip 面板 → 用户确认。
- Finder → 右键 `/tmp/mdgrip-ticket08-ui-target` → “服务”子菜单含 “Open with MDGrip”；调用成功，默认浏览器打开预览 → 用户确认。

实现者同时亲见（objective）：

- 新 domain `com.showgp.MDGrip` 启动前不存在；启动后 `defaults read` → `md-grip-first-use-guidance-shown = 1`（首用引导已自动呈现并记录）。
- LaunchServices/pbs 服务登记：bundle id `com.showgp.MDGrip`、`NSMessage openWithMDGrip`、`NSPortName MDGrip`、菜单名 `Open with MDGrip`、`NSRequiredContext com.apple.finder`、send type `public.file-url`。
- 服务调用打开目标后 `defaults read com.showgp.MDGrip` → `md-grip-recent-targets-v1`（JSON）含 `/tmp/mdgrip-ticket08-ui-target`（mode directory）与第二个目标 `/Volumes/GW2T_PICE3/workspace/02-web-apps/demos/docusaurus-projs/my-website/docs/dev-and-tech`；受管子进程 `.../Release/MDGrip.app/Contents/MacOS/md-grip --managed <uuid> -r -- <target>` 存活 ×2。

证据边界（披露）：

- 视觉证据为用户报告；`osascript` System Events 菜单栏查询返回 `missing value`（无辅助功能权限），实现者未独立见证菜单栏渲染，亦未截图。
- 私有 `NSPerformService` 程序化调用返回 `true` 但未产生会话；成功调用证据来自用户在 Finder 的真实调用。
- 服务登记当前解析到 Debug 构建路径（`.../Build/Products/Debug/MDGrip.app`），运行中的是 Release 产物；安装/登记指向属运维步骤。
- 未观察：宿主未运行时的冷启动服务调用；zh-Hans 服务名（“用 MDGrip 打开”）的运行时显示（仅静态 strings/pbxproj 核对）；挂载 DMG 内 App 的校验（`macos-candidate-check` 校验的是 archive 内 App，DMG 实挂证据见票 04）；v0.14.0 Release assets（task 3.2 遗留，见票 05）；Intel/macOS 13 真机。
- 旧 `/Applications/GoGrip.app` 仍在运行（含两个旧受管会话）——运维遗留，不在本票范围。

## Closure record

- 关闭:2026-10-10,状态 `done`。性质:验证-only 总验收票——按批准 seam 执行真实检查并记录观察;对 tracked 文件零写入,工件更新仅本票 Comments/状态与 `tasks.md` 勾选(均在未跟踪的 change dir 内)。
- 用户批准与裁决(2026-10-09/10):执行前批准"先跑 5.1–5.4、再与用户协同 UI 冒烟";D6 裁决选 A——以 `tasks.md` 5.1 的两类例外为操作性验收,`design.md` D6 字面形式(=空输出)已被 tasks 细化、工件不动,本节披露(审阅列为历史遗留 P2 advisory,非本票引入)。
- 实测证据(集成状态,本次亲见):
  - 5.1(字面命令):`grep -ri 'gogrip' . --exclude-dir=.git` 命中 46 条,全部位于 `openspec/changes/rename-to-md-grip/`(design 11、tasks 8、tickets 07/02/06/04/03/05/08/01 共 25、proposal 2),逐条核对均为本 change 自身工件中的映射表/旧串引用(类 b),change 外为 0;类 a 上游引用(`chrishrb/go-grip`,见 README:10/33/37/39/41、LICENSE:26)不匹配该无连字符 pattern,且以代码体形式在位。
  - 5.2:`go build ./... && go vet ./... && go test ./...` exit 0;补充 `go test -count=1 ./...` 全包 ok、`gofmt -l .` 为空。
  - 5.3:managed 会话 ready NDJSON(generation `ticket08-smoke`,url `http://127.0.0.1:53331/alpha.md`);`HEAD /__mdgrip/ready` → 204 + `X-MDGrip-Generation: ticket08-smoke`;旧路径 `/__gogrip/ready` → 404;`GET /` → 302 `/alpha.md` → 200(24,980 B,含 fixture marker 与 sidebar `href="/alpha.md"`);真实 Chromium 渲染 title `md-grip - markdown preview`、正文含 sidebar 与 marker;owner-loss(stdin 关闭)exit 0。
  - 5.4:`make macos-test` → `** TEST SUCCEEDED **`(95 tests / 0 failures,xcresult `Test-MDGrip-2026.10.09_22-13-10-+0800.xcresult`);`make macos` → `** BUILD SUCCEEDED **`;`make macos-candidate` → `** ARCHIVE SUCCEEDED **`×2、`MDGrip-arm64.dmg`(8,085,372 B)与 `MDGrip-x86_64.dmg`(8,875,537 B)、`candidate checks passed`×2;显式 `make macos-candidate-check` 再次通过×2;补充独立 `codesign -dv`:archive 内 app/tool `Identifier=com.showgp.MDGrip`/`com.showgp.MDGrip.md-grip`、`Signature=adhoc`。
  - 5.5:见本票 Comments(用户协同观察的视觉证据 + 实现者亲见的 defaults/registry/进程证据 + 边界披露)。
- 独立审阅(并行只读子代理 `ReviewStandards08`/`ReviewSpec08`,未复跑实现者检查、未改文件):Standards 轴首轮 1 阻塞 P2(观察记录未落盘)→ 记录落盘后定向复审 resolved(0 阻塞/0 新增);遗留 1 条 P2 advisory(D6 字面口径)已获用户裁决 A。Spec 轴首轮 PASS(0 阻塞;2 条 P3 advisory:archive-vs-DMG 校验表述、记录落盘)→ 定向复审两条均 resolved,0 新发现、0 未决裁决。覆盖限制:两轴未复跑检查、未独立见证运行时;Spec 轴另列未观察项(zh-Hans 服务名运行时显示、冷启动服务调用、Intel/macOS 13 真机、v0.14.0 Release assets 等)。
- 账本核对:5.1–5.5 整项验证标准均在集成状态观察 → `tasks.md` 五项勾选;task 3.2 保持未勾(票 05 保留的 v0.14.0 发布运维步骤,非本票映射)。`openspec instructions apply` 复核 20 项 / 19 完成,与文件一致。
- 运行时副作用披露:启动了 Release `MDGrip.app`(新 domain 写入 `md-grip-first-use-guidance-shown`、`md-grip-recent-targets-v1`;服务登记当前解析 Debug 构建路径,属安装运维步骤);/tmp 冒烟 fixtures 与私有调用脚本已清理,`/tmp/mdgrip-ticket08-ui-target` 因仍有存活会话保留。
- 未执行:提交、主规格同步、归档、下一票。
