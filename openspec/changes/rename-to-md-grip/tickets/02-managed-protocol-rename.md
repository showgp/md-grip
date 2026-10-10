# 受管协议标识符两端更名

Status: done
Blocked by: 01
Covers OpenSpec tasks: 1.3
Behavior source: None（协议标识符不在既有 spec 需求范围，App 与 CLI 锁版本同发、无外部消费者）
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

App 与内置 CLI 的私有受管协议改名，两端在同一变更内同步：ready 路径 `/__gogrip/ready` → `/__mdgrip/ready`、代际响应头 `X-GoGrip-Generation` → `X-MDGrip-Generation`、GCD queue labels `com.showgp.go-grip.managed-*` → `com.showgp.md-grip.managed-*`、受管测试工具临时路径 `/tmp/gogrip-managed-test-tool` → `/tmp/mdgrip-managed-test-tool`。无兼容层、无迁移。

## Acceptance

- [x] Go 侧与 Swift 侧旧标识符 grep 为空
- [x] `go test ./...`（含 managed 测试）通过
- [x] CLI 冒烟：启动后 `curl -I http://127.0.0.1:<port>/__mdgrip/ready` 返回且带 `X-MDGrip-Generation`

## Closure record

- 关闭:2026-10-09,状态 `done`。用户批准:本票范围、验证 seams（现有 Go/Swift 套件 + managed CLI 冒烟；不新增测试）与范围裁决——temp path 归本票（`Makefile` `macos-test` 与 Swift 集成测试同步，保持 staging 生产者/消费者一致）；执行许可:实现本票;不提交、不续票、不同步主规格、不归档。
- 变更面（本票，6 个 tracked 文件 + 1 个 gitignored 产物）：`internal/managed.go:24,28` 两常量；`cmd/managed_test.go:123,127` 协议字面量（任务 1.4 剩余命中）；`macos/GoGrip/Services/ManagedProcess.swift` 队列标签 ×3（:111,302,330）、头读取（:461）、ready 路径（:500）；`macos/GoGripTests/ManagedProcessTests.swift` 6 处头 fixture + 4 处路径 fixture（不随客户端改名必红，属 Swift 侧旧标识符清空面）；`macos/GoGripTests/ManagedProcessGoIntegrationTests.swift:15` staged 路径；`Makefile:27-29` 临时路径（其余旧产物名留票 04）；重建 `bin/md-grip`（gitignored）。无新增测试、无行为变更、无兼容层。
- 实测证据（集成状态，本次亲见）：
  - grep 零命中：`grep -rn '__gogrip\|X-GoGrip-Generation' --include='*.go' --include='*.swift' cmd internal pkg main.go macos`、`grep -rn 'com.showgp.go-grip.managed' --include='*.swift' macos`、`grep -rn 'gogrip-managed-test-tool' . --exclude-dir={.git,.build,openspec,bin}`、任务 1.4 的 `grep -ri 'gogrip' cmd internal pkg main.go go.mod`、任务 1.3 的 `grep -ri 'gogrip' internal/managed.go macos/GoGrip/Services/ManagedProcess.swift` 全部为空；仓库内协议旧串仅余 `docs/ARCHITECTURE.md:88,343,355`（任务 4.1/票 06 范围）。
  - `go build ./... && go vet ./... && go test ./...` 通过（cmd 4.16s，含进程级 managed 测试），`gofmt -l .` 空；`strings bin/md-grip` 旧串 0 命中、`__mdgrip` 命中。
  - `make macos-test`：`** TEST SUCCEEDED **`；xcresult 汇总 95/95 passed、0 skipped；含真实 Go 子进程的 `ManagedProcessGoIntegrationTests` 7 项、`ManagedProcessTests` 16 项通过；staged 工具实际落于新路径 `/tmp/mdgrip-managed-test-tool/GoGrip.app/Contents/MacOS/go-grip`（证明 Makefile 生产者与 Swift 消费者一致）。
  - CLI 冒烟：`./bin/md-grip --managed gen-smoke -- <tmpdir>` ready 事件 url `http://127.0.0.1:49806/README.md`；`curl -I http://127.0.0.1:49806/__mdgrip/ready` → `HTTP/1.1 204` + `X-Mdgrip-Generation: gen-smoke`（HTTP 头名线上大小写规范化，查找不区分大小写）；旧路径 `/__gogrip/ready` → 404（无兼容层）；ready URL GET → 200 含 fixture marker；owner-loss EOF 后退出码 0。
  - 未观察：App 真机界面与浏览器渲染（5.3/5.5，票 08）、打包/candidate（票 04/05）、docs/openspec 文本 sweep（票 06）。
- 独立审阅（并行只读子代理 `ReviewStandards`/`ReviewSpec`，未复跑实现者检查）：Standards 轴 PASS——0 阻塞/0 advisory/0 未决裁决；Spec 轴 PASS——0 阻塞/0 advisory/0 未决裁决（经核 4 份主规格与两份 delta 均不含协议标识符，`Behavior source: None` 成立；App 行为证据 5.3/5.5 为票 08 显式跟踪路径）。审阅覆盖限制：未重跑构建/测试/冒烟、未独立见证执行；无干净 git 固定点（票 01 改动未提交同树），按提供清单与直接文件检查审查。
- 账本核对：任务 1.3 验证标准（两文件旧串 grep 为空）已在集成状态观察 → 勾选；任务 1.4 余量（票 01 遗留 4 处协议标识符）随本票归零且 `go test ./...` 通过，全部贡献者（票 01、票 02）完成 → 依票 01 关闭记录的计划勾选。`openspec instructions apply` 复核 20 项 / 4 完成，与文件一致。未执行：提交、主规格同步、归档、下一票。
