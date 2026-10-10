# Spec Delta — macos-app-packaging

## MODIFIED Requirements

### Requirement: Architecture-split self-contained application
打包流程 SHALL 按 Apple Silicon(arm64)和 Intel(x86_64)架构分别生成候选 App,每个候选 App 内置同一版本、能在对应架构运行的 Go 渲染工具,并支持 macOS 13 及以上。用户使用某一架构的候选 App SHALL 不需要安装 Go、单独安装 CLI、配置 PATH 或保留源码目录;宿主与内置工具 SHALL 能在对应架构上共同提供完整预览功能。macOS 13+ 双架构覆盖 SHALL 由两个架构候选包共同满足,任一架构候选 App 只保证在对应架构运行。

#### Scenario: Use the application without development tools
- **WHEN** 用户运行对应架构打包生成的候选 App,环境中没有 Go 开发工具或额外安装的 md-grip CLI,也未配置其 PATH
- **THEN** App 使用随包提供的工具完成 Finder 或手动打开的目标预览,不要求从源码目录寻找二进制文件

#### Scenario: A candidate runs on its own architecture
- **WHEN** 用户在 Apple Silicon 上运行 arm64 候选 App,或在 Intel Mac 上运行 x86_64 候选 App
- **THEN** 宿主及随包工具在对应架构运行并提供完整预览功能

#### Scenario: Candidates together cover both architectures
- **WHEN** 检查两个候选包
- **THEN** 每个包仅含其架构的宿主与工具切片,并集覆盖 macOS 13+ 的 Apple Silicon 和 Intel

### Requirement: Candidate DMG and Services-only Finder integration

本阶段 SHALL 提供可生成上述候选 App 及可用于安装的候选 DMG 的打包流程:每个架构生成一个候选 DMG,文件名为 `MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg`,各包含对应架构完整 App 与 `/Applications` 快捷方式;打包流程 SHALL NOT 再产出 universal 候选 DMG 或候选 App zip。候选 App SHALL 包含服务注册和所需本地化内容,不包含遗留 Finder Sync 扩展或其专用转发兼容层;使用 Finder 入口 SHALL 不要求用户启用旧扩展。

#### Scenario: Produce an installable candidate
- **WHEN** 执行本阶段的打包流程
- **THEN** 产生 `MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg`,各包含对应架构完整 App 与 `/Applications` 快捷方式,安装后能提供本规格定义的 Services、菜单栏及预览功能

#### Scenario: Use the new Finder integration
- **WHEN** 用户安装候选 App 并按引导检查系统 Services 启用状态
- **THEN** Finder 打开能力由 Services 提供，不依赖随包发布或单独启用遗留 Finder Sync 扩展

### Requirement: Explicitly deferred formal distribution

本阶段 SHALL 交付完整功能及打包流程；Developer ID 签名、公证及正式安装包验证（含干净安装验证）SHALL 继续另行安排。通过 GitHub Release 公开发布 ad-hoc 签名的候选 DMG 属于本阶段交付范围；发布材料 SHALL 明确标注产物为 ad-hoc 签名、未经公证，SHALL NOT 将其表述为已完成公证或宣称普通用户安装信任流程已经验收。正式分发的签名、公证与干净安装标准 SHALL 不因公开发布候选产物而被取消。

#### Scenario: Present an unsigned candidate for functional review
- **WHEN** 本阶段提供尚未完成正式签名或公证的候选 App 或 DMG
- **THEN** 交付说明标明候选阶段及未完成的正式分发验证，不宣称普通用户安装信任流程已经验收

#### Scenario: Release candidate DMGs publicly
- **WHEN** 通过 GitHub Release 公开发布候选 DMG
- **THEN** 发布说明标注 ad-hoc 签名、未经公证及未完成的干净安装验证，不宣称普通用户安装信任流程已经验收

#### Scenario: Complete this implementation stage
- **WHEN** 完整功能及候选打包流程达到本阶段验收要求
- **THEN** 本阶段可以交付功能验收结果，但不因此获得正式签名、公证或干净安装验证的完成状态

### Requirement: Per-architecture candidate verification
打包流程 SHALL 对每个候选 DMG 及其中的 App 执行确定性校验:codesign 严格校验通过、Bundle ID 为 `com.showgp.MDGrip`、内置工具标识符为 `com.showgp.MDGrip.md-grip`、签名均为 ad-hoc;包内每个二进制 SHALL 通过其对应架构的 `verify_arch` 校验,SHALL NOT 通过另一架构的 `verify_arch` 校验。

#### Scenario: Verify a candidate before acceptance
- **WHEN** 打包流程完成对两个候选包的校验
- **THEN** arm64 包内宿主与工具均为 arm64 单架构,签名与标识符校验通过;x86_64 包同理

#### Scenario: Reject wrong architecture assignment
- **WHEN** 某候选包内的二进制包含错误架构切片,或同时包含 arm64 与 x86_64
- **THEN** 校验失败,该包不作为候选交付

### Requirement: CI uploads split candidate artifacts
CI release 工作流 SHALL 在候选打包时上传 `MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg` 作为 workflow artifact;正式发布产物的交付边界由 `Releases publish per-architecture DMG assets` 要求定义。

#### Scenario: Tag build produces candidate artifacts
- **WHEN** CI 运行 release 工作流
- **THEN** workflow artifact 包含 `MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg`

## ADDED Requirements

### Requirement: Releases publish per-architecture DMG assets
GitHub Release SHALL 在 CLI 归档之外附挂 `MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg`;校验和文件 SHALL 涵盖 CLI 归档与两个 DMG 在内的全部 Release assets。发布材料 SHALL 标注 DMG 为 ad-hoc 签名且未经公证，SHALL NOT 宣称已完成公证或普通用户安装信任流程已验收。同一 Release 内的 CLI 归档、校验和与 DMG SHALL 来自同一次构建且版本一致。

#### Scenario: Tag build publishes release assets
- **WHEN** tag 触发的 release 工作流完成
- **THEN** 该 Release 的 assets 同时包含 CLI 归档、涵盖全部资产的校验和文件、`MDGrip-arm64.dmg` 与 `MDGrip-x86_64.dmg`，且发布说明包含未公证声明
