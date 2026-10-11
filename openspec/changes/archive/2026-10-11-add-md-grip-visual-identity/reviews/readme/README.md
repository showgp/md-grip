# 票据 04 — README 顶部品牌图标：交付与观察记录

日期：2026-10-11

## 观察环境（本地渲染，非 GitHub 远端）

- 被渲染文件：仓库根 `README.md`（含本票一行插入，工作区未提交状态）
- 渲染程序：`make build` 产出的 `bin/md-grip`（当前工作区构建，直接消费票据 02 已经交付的 `docs/brand/mdgrip.png`，未运行任何图像导出步骤）
- 服务方式：目录模式伺服仓库根，`./bin/md-grip . --browser=false --port 6419 --no-reload`；非 markdown 路径由内置 fileServer 解析，`/docs/brand/mdgrip.png` 实际加载成功
- 浏览器：browser 工具管理的真实 Chromium（headless，共享进程），视口 1280×900，新分页全新上下文
- **本记录仅代表本地渲染观察，不声称观察了 GitHub 远端 README 页面**（资源尚未 push，远端页面观察不可用也不伪造）

## 插入内容与最小性

`README.md` 在 `# md-grip` 标题后、介绍段落前插入一行：

```html
<img src="docs/brand/mdgrip.png" alt="MDGrip" width="96" />
```

- Markdown 图片语法无法设置显示宽度，按 design Decision 5 使用单行内联 HTML，`width=96`、`alt="MDGrip"`、本地相对路径
- `git diff --numstat` 全程实测：`README.md` 仅 +2/−0（img 行与其空行），其余内容零改动
- 未新增字标、主题切换图片、社交预览素材；未改动 GitHub 头像、About、topics、仓库设置（本票未执行任何远端或仓库设置操作）

## 浏览器内实测（page.evaluate，非 DOM/源码搜索）

| 观察项 | 深色（初始渲染） | 浅色（页内切换后） |
| --- | --- | --- |
| alt | `MDGrip` | `MDGrip` |
| 资源 URL | `http://localhost:6419/docs/brand/mdgrip.png`（HTTP 成功，`naturalWidth=512` 正常加载） | 同左 |
| natural 尺寸 | 512×512（票据 02 交付资产，透明 RGBA） | 同左 |
| 渲染 rect | 96×96 px | 96×96 px（切换主题后复测不变） |
| 位置 | `<h1>md-grip</h1>` 的下一个兄弟元素，介绍段之前 | 同左 |
| body 背景 | `rgb(13,17,23)`（GitHub 深色 #0d1117） | 白色浅色背景 |

主题切换通过页面真实 UI 完成：点击 `#theme-toggle` 按钮（title `Theme: Dark`，☾），切换后为浅色背景；非强制 color-scheme 仿真，非图片查看器单独打开。

## 截图证据（本目录）

- `01-dark-top.png` / `03-light-top.png`：浏览器实际渲染的 README 顶部（标题、图标、介绍、Table of Contents 开头，clip 680×340）
- `02-dark-icon.png` / `04-light-icon.png`：图标元素特写（截图导出为 120×120 帧缘）
- 两组截图均可见：
  - 图标位于原标题之后、介绍之前，与标题、正文布局协调，无遮挡无裁切
  - 深色背景：蓝色文档面 + 白色预览窗对照清晰；浅色背景：同一图形深色描边清晰；透明 alpha 正常生效
  - 标题、介绍、目录与各章节照旧渲染，无内容或布局变化

## 保持不变的证明

- Git 全程基线：本票开始前 `README.md` 无任何未提交改动（该文件从 HEAD 干净基线出发），结束时 diff 仅上述两增加行
- 未触碰票据 02/03 已交付文件与既有无关用户改动（`AGENTS.md`、`.agents/skills/tasks-to-tickets/SKILL.md` 等保持原样）
- 附带验证：全部现有 Go 测试均使用各自 temp-dir 内自建的 `README.md` fixture，没有任何测试读取仓库真实 README，无需也不会接线测试

## 测试边界（票据规定）

- 未新增任何断言 README 文案或图片引用的永久测试；票据与任务 3.2/4.2 明确禁止此类测试
- 验证全部为真实操作记录：`git diff`、`make build`、真实服务器 + 真实浏览器渲染测量与截图

## 未验证项

- GitHub 远端 README 页面（默认分支 push 后的最终渲染）：未观察，归为未验证环境；本票按票据规定明确"仅本地渲染"
- 本地 md-grip 渲染器与 GitHub 渲染器对 `<img>` 96px 的处理一致性未在远端逐一验证
