# Spec Delta — macos-finder-service

## MODIFIED Requirements

### Requirement: Finder Services entry

应用 SHALL 提供“用 MDGrip 打开”的 macOS Services 命令，让用户从 Finder 对已选目标执行打开操作。宿主未运行时，服务请求 SHALL 能启动宿主并处理所选目标，不以登录启动已开启为前提。应用 SHALL 接受系统决定的服务菜单位置和用户启用状态，不要求右键菜单第一层或目录空白处入口。

#### Scenario: Open a selected folder from Finder
- **WHEN** 用户已安装应用并在系统允许显示该服务的情况下，对 Finder 中选中的可访问目录调用“用 MDGrip 打开”
- **THEN** 应用接收该目录并按预览会话规格打开预览，不要求用户执行终端命令

#### Scenario: Invoke the service while the host is not running
- **WHEN** 登录启动未开启、宿主未运行，用户对有效目标调用已启用的服务
- **THEN** 系统启动宿主，应用处理本次目标并请求浏览器打开预览，无需用户先手动启动宿主
