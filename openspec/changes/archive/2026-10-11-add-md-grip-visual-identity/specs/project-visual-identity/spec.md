# Spec Delta

## Purpose

为 MDGrip 提供覆盖 macOS 菜单栏、App、仓库与浏览器预览的共同原创视觉身份，明确各场景的识别与适配要求、用户选择候选方案的边界，以及可编辑资产、许可、预览网页页脚品牌文案和实际展示验收的交付契约。本能力只改变视觉资产、必要接入及指定页脚文案，不改变既有产品功能和分发要求。

## ADDED Requirements

### Requirement: Shared original visual identity

项目 SHALL 以 Markdown 预览工具作为覆盖 CLI 与 macOS App 的共同品牌定位，以文档与预览窗口融合的简洁几何符号为核心；图标 SHALL 不含文字。彩色版本 SHALL 使用克制的蓝色主色系，App 图标 SHALL 以平面为主、保留轻微层次，仓库版本 SHALL 使用简化平面表达。各版本 SHALL 保留共同核心轮廓，并按场景调整线宽、留白与细节，而不是要求完全相同的图片直接缩放。图形 SHALL 原创，不复用或改造上游图标，不使用许可不明的第三方素材。

#### Scenario: Recognize the identity across surfaces
- **WHEN** 用户比较状态栏图标、App 图标、仓库图标与网页 favicon
- **THEN** 各版本具有同源的核心轮廓，以文档与预览窗口的融合图形表达 Markdown 预览，不依赖文字识别；彩色版本使用一致的蓝色主色系，单色与简化版本仍保留共同识别元素

#### Scenario: Deliver an independent original identity
- **WHEN** 审阅最终图形及其来源
- **THEN** 交付使用原创图形，不以复用或改造上游图标作为独立品牌方案，也不包含许可不明的第三方素材

### Requirement: User selection precedes refinement and integration

设计评审 SHALL 先提供两个符合共同视觉约束的低保真方向，展示各自轮廓与构图在状态栏小尺寸、App 和仓库场景中的表现。用户选定一个方向后，交付 SHALL 仅沿该方向精修、确定具体色值并接入；选定前 SHALL NOT 提前精修全部候选或将未选定方向作为最终图标接入。候选评审 SHALL 允许使用模拟展示，但模拟展示 SHALL NOT 代替最终实际接入验收。

#### Scenario: Compare candidates before selection
- **WHEN** 用户尚未选定方向并进行候选评审
- **THEN** 用户获得两个低保真方向及其小尺寸、App 和仓库场景展示，用于比较轮廓与构图，而不是两个已经精修并接入的最终方案

#### Scenario: Refine the selected direction
- **WHEN** 用户明确选定一个候选方向
- **THEN** 后续精修、具体色值确认、资产导出与接入均沿该方向进行，不以另一个未选定方向替代用户选择

### Requirement: Monochrome menu bar identity

App SHALL 使用原创图形的单色 template 状态栏版本替换现有通用系统图标，在正常菜单栏显示尺寸下保持清晰，并适应浅色与深色菜单栏。状态栏图标 SHALL 仅标识应用，不引入忙碌、成功、错误等状态表达或切换机制；替换 SHALL 保持现有点击与面板交互及无 Dock 图标的应用激活行为。

#### Scenario: Use the icon in light and dark menu bars
- **WHEN** 用户在浅色或深色菜单栏中查看正常尺寸的 MDGrip 状态栏图标并点击它
- **THEN** 原创单色图形在对应背景下清晰可辨，点击仍按既有行为打开或关闭面板，不因新图标出现 Dock 图标或新的状态显示机制

### Requirement: Application icon accompanies packaged applications

App SHALL 使用共同身份的彩色 App 图标，在 Finder 与应用程序目录中正确展示；现有打包流程交付的 App SHALL 包含所需图标资源，不依赖源码目录或额外设计工具提供图标。图标接入 SHALL 保持既有 App 与 DMG 交付形式、架构、标识符及签名要求，不为展示 App 图标而新增 Dock 常驻行为。

#### Scenario: View a packaged application in Finder
- **WHEN** 用户在 Finder 或应用程序目录中查看现有打包流程生成的 MDGrip App
- **THEN** 系统展示选定方向的彩色 App 图标，打包后的 App 包含该图标所需资源，而不是使用通用应用图标或从源码目录寻找资产

### Requirement: Minimal repository icon integration

README SHALL 在顶部展示共同身份的简化平面仓库图标，并在浅色与深色页面背景下保持可辨认。本次 README 变更 SHALL 仅接入该图标，不重写项目介绍、章节或截图，不重设计整体布局，并保留上游来源、已有版权及现有安装与候选分发说明。仓库图标交付 SHALL NOT 修改 GitHub 个人头像、About、topics 或仓库设置。

#### Scenario: Read the repository introduction in either theme
- **WHEN** 用户在浅色或深色页面背景下查看 README 顶部
- **THEN** 仓库图标清晰可辨并与 App 使用同源图形，现有介绍、章节、截图、来源、版权、安装与候选分发说明保持不变

### Requirement: Browser preview uses the shared favicon

Markdown 预览网页 SHALL 使用从共同图形派生、适配浏览器标签小尺寸的 favicon，替换现有网页图标。替换 SHALL 仅改变视觉资产及必要接入，不改变预览功能，不引入外部资源服务或新的页面功能。

#### Scenario: Open a real Markdown preview
- **WHEN** 用户通过 MDGrip 打开实际 Markdown 预览网页并查看浏览器标签
- **THEN** 浏览器标签显示选定方向派生的 favicon，网页继续提供既有预览功能，不需要从外部资源服务加载该图标

### Requirement: Preview footer identifies MDGrip without changing attribution records

预览网页 SHALL 将现有页脚文案 `Made with ♥ by chrishrb` 替换为 `Rendered with MDGrip`，保持原有页脚位置、样式和显示条件，不重设计页面。替换 SHALL 仅更正界面品牌文案，不改写 LICENSE 中的上游版权或 README 中的项目来源说明；既有显示条件不成立时，网页 SHALL 继续不展示该页脚。

#### Scenario: Display the updated footer under the existing condition
- **WHEN** 用户打开实际 Markdown 预览网页，且既有页脚显示条件成立
- **THEN** 页脚在原有位置、样式下显示 `Rendered with MDGrip`，不再显示旧文案；LICENSE 上游版权和 README 项目来源说明保持不变

#### Scenario: Preserve the existing hidden footer behavior
- **WHEN** 用户打开实际 Markdown 预览网页，且既有页脚显示条件不成立
- **THEN** 网页继续不展示该页脚，不因品牌文案替换新增常驻页脚或改变页面布局

### Requirement: Editable MIT-licensed asset delivery

交付 SHALL 包含可编辑 SVG 源文件、四类使用位置所需的已导出资产及简短导出说明。原创图标与源文件 SHALL 沿用项目 MIT 许可，不引入独立图标许可或额外品牌使用限制，不改写上游来源与已有版权说明。正常构建 SHALL 直接使用已提交资产，不要求安装设计或图像导出工具；这些工具 SHALL 仅用于资产维护，不成为运行依赖。

#### Scenario: Maintain the visual assets
- **WHEN** 维护者需要调整或重新导出图标
- **THEN** 仓库提供可编辑 SVG 源文件及简短导出说明，并包含状态栏、App、README 与 favicon 所需的最终导出资产，原创资产按项目 MIT 许可提供

#### Scenario: Build without graphics export tools
- **WHEN** 开发环境具备既有正常构建所需工具，但未安装设计或图像导出工具
- **THEN** 正常构建直接使用已提交的图标资产，不要求先运行设计或图像导出工具，也不为运行时增加此类依赖

### Requirement: Acceptance observes actual integrated surfaces

最终验收 SHALL 实际观察正常尺寸的浅色与深色菜单栏、Finder 与应用程序目录中的 App 图标、README 浅色与深色背景，以及真实预览网页的浏览器标签和页脚文案，并检查打包后的 App 包含图标资源。网页页脚验收 SHALL 覆盖既有显示条件成立与不成立的场景。验收 SHALL 明确区分实际观察、静态检查与未验证环境，不以设计稿、模拟图、仅构建成功或资源文件存在代替实际展示结果，也不以某一环境的结果声称完成未观察的平台验证。

#### Scenario: Record final integration evidence
- **WHEN** 本次视觉身份变更提交最终验收结果
- **THEN** 记录包含上述实际展示观察与打包资源检查，并明确标注未验证环境；候选阶段的模拟图或构建结果不被表述为最终实际展示验证通过
