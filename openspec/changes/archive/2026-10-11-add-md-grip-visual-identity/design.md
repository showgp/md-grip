# Design

## Context

动机见 `proposal.md` 的 Why；行为与交付边界以 `specs/project-visual-identity/spec.md` 为准。本设计同时涉及 macOS 资源、Go 嵌入静态资源和 README 展示，需要在实现前确定导出与接入方式。

当前接入点：

- `macos/MDGrip/AppDelegate.swift` 的 `setupStatusItem()` 使用系统符号 `doc.text`，按钮已有 target/action；无需更改面板或会话逻辑。
- `macos/MDGrip.xcodeproj/project.pbxproj` 的 Debug/Release 已指定 `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon`，但没有资产目录引用；Resources 阶段当前只包含本地化资源。
- `macos/MDGrip/Info.plist` 设置 `LSUIElement = true`，没有 App 图标键。保持 accessory 应用行为，由资产编译过程提供图标资源与相应的构建产物元数据。
- `Makefile` 的 `macos`、`macos-archive`、`macos-dmg`、`macos-candidate` 已覆盖开发构建与双架构候选打包；`macos/Scripts/build-md-grip.sh` 负责内置工具构建和签名，不负责图像导出。
- `defaults/templates/layout.html` 已引用 `/static/images/favicon.ico`；`defaults/embed.go` 嵌入整个 static 目录。favicon 替换原位置文件即可随 CLI 和内置工具构建交付，无需修改其模板引用、路由或嵌入规则；页脚文案另以最小模板替换处理。
- 同一模板在 `{{if .BoundingBox}}` 内展示 `Made with &hearts; by chrishrb`。`cmd/root.go` 已有 `--bounding-box` 布尔参数，默认 true；无需新增配置即可分别观察现有页脚显示与隐藏场景。模板本身已由 `defaults/embed.go` 嵌入。
- README 顶部为文字标题和介绍，没有图标。现有 `.github/docs/` 保存示例截图，没有可复用的品牌源文件组织方式。

本地已确认可用 `rsvg-convert 2.62.2`、`ImageMagick 7.1.2-29` 和 Xcode 27.0。这些观测只证明维护工具可用，不代表新图标已完成导出、接入或视觉验证。

## Goals / Non-Goals

**Goals:**

- 将可编辑源文件与各消费位置的最终资产明确分离，正常构建不承担导出责任。
- 以一个 Xcode 资产目录接入 App 和状态栏图标，以原 favicon 路径接入网页，以一个本地图片引用接入 README。
- 仅替换既有网页页脚的品牌文案，保留其 DOM、CSS 和 `.BoundingBox` 条件，以及 LICENSE 上游版权和 README 项目来源。
- 将用户选定方向作为精修与接入的前置条件；最终以真实展示和现有打包产物验收。

**Non-Goals:**

- 不建立参数化图标生成框架、设计令牌系统、运行时主题资源切换或新的导出流水线。
- 不增加发布工作流、运行时依赖、系统符号兼容回退或用于断言源文件文字、资源引用的永久测试。
- 不替代 proposal 中的非目标，也不将新视觉资产的验收扩大为签名、公证或跨环境安装信任验证。

## Decisions

### 1. 用两个低保真方向确定轮廓，不在设计文档中提前定稿

两个方向均遵守已批准的“文档与预览窗口融合”概念，以构图和轮廓差异作为比较对象；每个方向展示状态栏正常尺寸、App 和仓库场景。候选 SVG 与对比图片作为本变更的评审材料，放在变更目录下 `reviews/candidates/`，不进入 App 或网页资源。

用户明确选定一个方向后，才制作最终色彩、轻微层次和各场景适配。选定结果及后续展示意见记录在本变更的评审材料中，不把未选定候选保留为运行时可切换方案。当前不制作候选，也不提前指定具体轮廓或蓝色色值。

替代方案：直接精修单个方案更快，但不满足已批准的两个方向比较；精修两个完整方案增加无必要工作，也越过用户选择边界。

### 2. 用少量独立 SVG 表达同源适配，按消费位置保存导出资产

最终资产布局：

| 位置 | 内容与用途 |
|---|---|
| `docs/brand/brand-mark.svg` | 仓库平面标记的可编辑源文件，表达共同核心轮廓 |
| `docs/brand/app-icon.svg` | App 图标源文件，包含选定的蓝色、轻微层次及 macOS 图标留白 |
| `docs/brand/status-bar.svg` | 小尺寸单色版本的源文件，调整线宽、留白与细节 |
| `docs/brand/favicon.svg` | 浏览器标签小尺寸适配的源文件 |
| `docs/brand/mdgrip.png` | README 使用的透明背景 PNG，导出为 512 × 512 |
| `docs/brand/README.md` | 简短资产维护说明：源文件对应关系、导出命令、尺寸、工具及沿用项目 MIT 许可 |
| `macos/MDGrip/Assets.xcassets/` | App 与状态栏已导出 PNG、资产目录描述文件 |
| `defaults/static/images/favicon.ico` | 网页实际使用的多尺寸 ICO，沿用现有路径 |

不同 SVG 保留共同核心轮廓，但允许场景特定的几何适配。SVG 直接使用几何形状和路径，不依赖字体、链接图片或在线素材。四个源文件是可编辑交付，而非新建一个生成所有图形的抽象层。README PNG 和运行时导出文件不额外复制到另一个发布资产目录。

替代方案：一个 SVG 机械缩放容易损失小尺寸识别；只交付 PNG 缺少可编辑来源；专有工程文件增加维护门槛，且不在批准范围内。

### 3. 通过常规 macOS asset catalog 接入，不手工维护第二套图标包

新增 `Assets.xcassets` 并按现有显式工程引用方式加入 MDGrip target 的 Resources。目录包含：

- `AppIcon.appiconset`：提供 macOS 16、32、128、256、512 pt 的 1×/2× 槽位；所需像素尺寸为 16、32、64、128、256、512、1024。同像素尺寸的槽位可引用同一 PNG，不重复保存相同导出文件。
- `StatusBarIcon.imageset`：提供 18 × 18 的 1× 和 36 × 36 的 2× 透明 PNG，以黑色及 alpha 表达单色图形，资产设置 template 渲染。

`setupStatusItem()` 只将图像来源换为名为 `StatusBarIcon` 的 bundle 资产，保持 18 pt 逻辑尺寸、template 属性及 `MDGrip` 无障碍描述；保留现有 target/action。图像在状态栏设置时加载，不为每次点击生成或缩放位图，也不新增主题监听器或图标状态机。图形以实际模板着色效果验收，而不是把源文件中的黑色作为最终菜单栏颜色。

App 图标由现有 `AppIcon` 构建设置和 Xcode asset compiler 处理，不并行提交手工 `.icns`、不额外用 Info.plist 建立另一条图标加载路径。检查构建后的 App 图标元数据与资源，再在 Finder 观察展示；不凭工程配置存在推断系统展示正确。图标背景、圆角和留白绘制在 App 源图中，不假定 macOS 会为任意方形图片自动完成所需外观。

替代方案：手工 `.icns` 与单独 PNG 复制步骤会绕过已有 AppIcon 配置并增加维护路径；运行时读取 SVG 引入不必要的渲染与路径依赖。继续使用系统符号回退会隐藏资源接入遗漏，不作为交付方案。

### 4. 维护者离线导出，正常构建只消费已提交文件

维护说明给出直接导出命令：使用 `rsvg-convert` 按目标尺寸从各 SVG 输出 PNG；favicon 从其适配源文件导出 16、32、48 px 临时 PNG，再用 ImageMagick 合成为一个 ICO。App 各尺寸从 App 源文件导出，状态栏从其单色源文件导出，README 从平面源文件导出。临时导出文件不作为最终交付保留。

对小尺寸导出实际检查轮廓、线宽和留白，必要时调整相应 SVG，而不是为了复用命令强行缩放大图。图像导出工具版本与命令记录在资产维护说明中；不增加跨工具版本字节一致性的保证。

正常 Go/Xcode 构建直接消费已提交 PNG、ICO 与 asset catalog 描述文件，不调用 `rsvg-convert`、ImageMagick 或其他设计工具。现有 Makefile、内置工具脚本与 Release 工作流无需为导出增加步骤。`iconutil` 可用于人工检查构建产物，不成为另一套生成或构建路径。

替代方案：构建时自动生成图标会让所有贡献者和 CI 安装只在维护资产时才需要的工具；新增维护脚本或 Make target 对本次有限尺寸导出没有必要。

### 5. README、favicon 与页脚采用最小接入

README 保留现有 `# md-grip` 标题及所有文字，在标题后、介绍前增加一个引用 `docs/brand/mdgrip.png` 的本地图标，初始显示宽度 96 px，alt 为 `MDGrip`。使用透明背景和在浅深背景均清晰的主体，不新增主题切换图片、居中标题体系或社交预览素材。

favicon 保持 `/static/images/favicon.ico` 路径与现有 link；文件替换后随 Go embed 交付，不增加 CDN、页面脚本或另一套主题图标。若浏览器仍显示旧图标，验收使用干净浏览器上下文和新启动的预览实例，区分缓存问题与实际资源遗漏，而不是借机改写服务的缓存策略。

页脚只将 `defaults/templates/layout.html` 中的 `Made with &hearts; by chrishrb` 改为纯文本 `Rendered with MDGrip`。保留外层 `{{if .BoundingBox}}`、footer 元素、`docs-footer-inner` 与相关 CSS；不增加链接、图标、配置项或常驻页脚。LICENSE 与 README 来源说明不属于该文案替换范围，不做全仓作者名替换。模板改动随现有 Go embed 编译进入 CLI 与 App 内置工具。

删除页脚会改变现有展示结构，改为另一位作者署名会混淆项目来源；均不采用。工具品牌文案更正不承担版权声明职责。

替代方案：仅保存仓库图标不展示它不能完成已批准的最小接入；多主题图片或外部图标服务增加资源与维护路径，没有对应需求。

### 6. 将结构检查、功能 smoke 与实际视觉观察分开记录

验收按已批准规格组织，不新增对资源引用、文件文字或导出副本的永久测试：

| 检查层 | 方法与证据 | 不可替代的边界 |
|---|---|---|
| 资产结构 | 检查 PNG/ICO 尺寸、asset catalog 编译结果及打包 App 的图标元数据和资源 | 文件存在不证明系统显示正确 |
| 状态栏 | 启动真实 App，观察浅色与深色菜单栏正常尺寸，点击检查原有面板交互与无 Dock 行为 | 候选模拟图不替代实际 template 着色 |
| App/DMG | 沿用 `make macos-candidate` 生成 arm64/x86_64 候选并执行既有签名和架构检查；挂载 DMG 检查 App，在本机可运行的架构上启动并观察；在 Finder 及应用程序目录观察图标 | 两种架构均可检查资源，但本机视觉结果不等于另一种硬件运行验证，也不等于安装信任验证 |
| README | 在浏览器实际渲染 README，观察浅色和深色背景；不具备远端提交展示条件时，使用本地渲染并标明观察环境 | 本地渲染不声称等同 GitHub 远端最终展示 |
| 网页图标 | 用实际构建的 md-grip 打开真实 Markdown 预览，在浏览器标签观察 favicon，同时确认页面仍能预览内容 | 下载 ICO 或浏览器 DOM 中有 link 不等于标签实际显示 |
| 网页页脚 | 分别以 `--bounding-box=true` 和 `--bounding-box=false` 打开真实预览：前者在原位置、样式下显示 `Rendered with MDGrip`，后者仍不展示页脚；记录实际页面观察，并核对 LICENSE 和 README 来源说明未改 | 只搜索模板文本不能代替实际页面验收；不新增文案或源码文字断言类永久测试 |
| 构建依赖 | 检查既有构建入口没有图像导出步骤，并正常构建 Go 与 App；已提交资产无需先运行导出命令 | 本地已安装导出工具这一事实不能单独证明构建不依赖它们 |

证据记录在本变更评审材料中，标明观察环境、截图或操作结果、结构检查与未验证项。真实 UI 的可见性或权限不足时记录准确缺口，不以模拟图补报通过；已批准的最终验收项仍需补齐后才能关闭。现有行为测试若因资源接入受影响则修复其契约，不为本次图标替换新增 wiring 测试。

## Risks / Trade-offs

- [复杂图形缩小后失去识别] → 优先比较正常尺寸轮廓；状态栏和 favicon 使用各自适配源文件，去掉不能稳定显示的细节。
- [App、仓库和浏览器版本逐渐偏离] → 以选定核心轮廓作为共同参照；精修评审同时展示四种版本，不建立额外设计系统。
- [透明图形在浅深背景中的对比不足] → 在实际菜单栏和 README 两种背景观察；菜单栏由系统 template 着色，其余资产调整自身图形，不引入运行时主题切换。
- [Finder 或浏览器缓存让旧图标继续显示] → 使用新构建产物及干净观察上下文确认真实资源；不为缓存现象加入产品逻辑。
- [资产目录漏入 target 或只在开发构建中可用] → 通过现有 archive/DMG 流程检查两个架构的打包资源，再实际观察 Finder，不只运行 Debug 构建。
- [导出工具版本差异改变像素结果] → 提交最终导出文件并记录维护命令；更新源文件后重新观察，不承诺未批准的字节级可重复性。
- [当前环境不能观察全部真实 UI] → 明确区分已观察、结构检查和未验证环境；缺失的必需展示验收不被静态检查替代。

## Migration Plan

1. 规划文档逐份审阅后，按仓库既有单票流程实施；先交付两个低保真方向并停下等待用户选择，不将当前 design 审批视为候选选择或实现授权。
2. 用户选定方向后，精修同源的四个版本，提交 SVG、导出资产与简短维护说明。
3. 接入 asset catalog 和状态栏图像，完成 README 最小插入、原路径 favicon 替换与指定页脚文案替换；不改页脚位置、样式和显示条件，不改既有打包和发布边界。
4. 沿现有构建与候选打包路径完成结构检查、功能 smoke 和真实视觉验收，记录证据与环境限制；不在本次变更中发布新版本。
5. 回退时仅撤销本变更的资源及接入：状态栏恢复原系统符号，移除新增资产目录引用与 README 图标，恢复此前 favicon 与页脚文案；不撤销无关代码、仓库设置或既有发布产物。

## Open Questions

- 两个候选的具体轮廓由候选评审选择，具体蓝色色值及轻微层次在选定方向后的精修评审确定。这些已批准的设计阶段决策不改变资产布局、接入方式或验收契约；实现时不得以默认推荐代替用户选定方向。
