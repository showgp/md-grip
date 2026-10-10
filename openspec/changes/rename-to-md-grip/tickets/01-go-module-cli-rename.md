# Go 模块与 CLI 更名

Status: done
Blocked by: None
Covers OpenSpec tasks: 1.1, 1.2, 1.4
Behavior source: None（module path、命令名与构建产物名不在既有 spec 需求范围）
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

仓库的 Go 身份整体改为 md-grip：module path 变更为 `github.com/showgp/md-grip`，全部 Go import 随之更新；CLI 命令名与二进制名变为 `md-grip`；Makefile、mise.toml、flake.nix 的 Go 构建产物名同步（design D1 表为准）。用户可见结果：`go run . --help` 与安装产物均为 md-grip。

## Acceptance

- [x] `go build ./...` 通过，`.go` 文件与 `go.mod` 中无 `showgp/go-grip` 引用
- [x] `go run . --help` 头部显示 `md-grip`
- [x] `make build` 产出 `bin/md-grip*`
- [x] `go vet ./... && go test ./...` 通过

## Closure record

- 关闭:2026-10-09,状态 `done`。用户批准:本票范围与验证 seams(既有套件 + 构建/help/冒烟 + grep 清单);范围裁决——`defaults/**` 旧名清扫(含 `internal/export_test.go` 联动)并入本票、`.gitignore` 孤儿条目 `/go-grip` 由本票删除。执行许可:实现本票;不提交、不续票、不同步主规格、不归档。
- 变更面(本票,20 个 tracked 文件,60+/61-):module path 与 import(`go.mod`、`main.go`、`cmd/root.go`、`internal/{server,export,pdf,managed,parser}.go`、`cmd/managed_test.go`);CLI 与产物名(`cmd/root.go:14`、`Makefile:4`、`mise.toml:25,39-44`、`flake.nix:2,25`);测试与资产字符串(`cmd/{cli,managed}_test.go` 的 `startMDGrip`/临时路径/bin 名、`defaults/templates/{layout,export,print}.html` 标题、`defaults/static/js/{theme-switch,editor}.js` 存储键、`internal/export_test.go:47`);`.gitignore` 删除 `/go-grip`。无新增测试、无行为变更。
- 实测证据(集成状态,本次亲见):
  - `grep -rn 'showgp/go-grip' --include='*.go' .` 与 `go.mod` 零命中;`grep -ri 'gogrip' cmd internal pkg main.go go.mod` 恰余 4 处协议标识符(`internal/managed.go:24,28`、`cmd/managed_test.go:123,127`,任务 1.3/票 02 范围,未触);`go-grip|gogrip` 在 mise.toml/flake.nix/.gitignore/defaults/ 清零。
  - `go build ./... && go vet ./...` 通过,`gofmt -l .` 为空;`go test ./...` 全部包 ok(含 cmd 进程级测试以新 module path 构建二进制)。
  - `go run . --help` 与 `./bin/md-grip --help` 头部 `Usage: md-grip [file] [flags]`;`make build` 产出 `bin/md-grip`(文件已观察)。
  - 独立冒烟:`./bin/md-grip --json --browser=false --port 0 -- <tmpdir>` 服务页面标题 `<title>md-grip - markdown preview</title>`、正文含 fixture marker,进程已终止。
  - 未观察:mise/Nix 构建、macOS/release 流水线(后续票范围)、export/print 的 CLI 手工冒烟(export 标题由 `internal/export_test.go` 断言覆盖且通过;print/PDF 渲染未手工执行)。
- 独立审阅(并行只读子代理 `ReviewStandards`/`ReviewSpec`,未复跑实现者检查):Standards 轴 0 阻塞/0 advisory/0 未决裁决;Spec 轴 0 阻塞/0 advisory/0 未决裁决(经核本票无行为规格增量,仅审批准非行为范围,非行为 Spec 通过)。审阅覆盖限制:未重跑构建/冒烟、未独立见证执行。
- 账本核对:任务 1.1、1.2 整项验证标准已在集成状态观察,`tasks.md` 两项已勾;任务 1.4 保持未勾——余下 4 处协议标识符属任务 1.3(票 02,Blocked by: 01),票 02 完成后该 grep 归零方可勾选;`openspec instructions apply` 复核 20 项 / 2 完成,与文件一致。未执行:提交、主规格同步、归档、下一票。
