# macOS App 图标接入实测记录（票据 03）

**性质：真实 App 实机观察的验收记录**——非模拟图。观察环境：本机（macOS 27.0.1，两台 2560 × 1440 显示器，深色模式为用户默认状态，观察后已还原），构建产物为 `make macos`（Release，ad-hoc 签名）生成的 `macos/.build/DerivedData/Build/Products/Release/MDGrip.app`。观察时间 2026-10-11 12:55–13:15（本目录文件时间戳）。

版本标签勘误：原记录误写为 macOS 26，现依据票据 07 核对的实际系统版本纠正为 macOS 27.0.1；本次仅修正文档标签，未重新运行原观察。

## 1. 结构检查（静态，不替代视觉验收）

| 检查 | 结果 |
|---|---|
| `make macos` | BUILD SUCCEEDED（构建入口无任何图像导出步骤） |
| 产物 `Contents/Resources/` | 含 `Assets.car` 与 `AppIcon.icns` |
| 产物 `Contents/Info.plist` | `CFBundleIconName = AppIcon`；`LSUIElement = true`（保持不变） |
| `assetutil --info Assets.car` | `AppIcon`（Icon Image）renditions：`icon_16x16`、`icon_16x16@2x`、`icon_128x128`、`icon_128x128@2x`、`icon_256x256@2x`、`icon_32x32@2x`、`icon_512x512@2x`；`StatusBarIcon` 两条 rendition 18×18@1x、36×36@2x，均带 `"Template Mode": "template"` |
| `make macos-test`（回归 sanity） | TEST SUCCEEDED，95 tests / 0 failures |

同像素槽位共用同一 PNG（32 px 槽引用 `icon_16x16@2x.png`、256 px 槽引用 `icon_128x128@2x.png`、512 px 槽引用 `icon_256x256@2x.png`），未新增导出副本，与 `docs/brand/README.md` 约定一致。

## 2. 状态栏实测（真实菜单栏，template 着色）

- 截态文件：`menubar-dark.png`（原始带）+ `menubar-dark-zoom.png`（×10 放大）：深色菜单栏下状态项显示**白色 template 着色的"叠窗"图形**（页面 + 右上折角 + 右下前窗块），轮廓清晰——不再是通用系统符号 `doc.text`。
- 源 PNG 为黑 + alpha；实际显示白色证明系统 template 属性生效，未依赖源文件黑色。
- AppleScript System Events 读取该状态项 `description = "MDGrip"`：无障碍描述已随 bundle 资产生效。
- 状态项几何：position `{1859,3}`、size `{36,24}`（主屏 2560×1440）——18 pt 逻辑图形 + 系统按钮内边距，未出现位图缩放痕迹（无模糊溢出）。

## 3. 面板开关实测（原 target/action 不变）

| 操作 | 证据 |
|---|---|
| 点按状态项 → 原面板打开 | `popover-open-dark.png`（Sessions / Recent / Launch at login 完整呈现，锚定状态项下方） |
| 再次点按 → 面板关闭 | `popover-closed-dark.png`（同一区域已无面板） |
| 浅色外观下点按 → 打开 | `popover-open-light.png` |

全部通过 AppleScript 对原菜单项执行系统点按，未新增任何点击处理代码。

## 4. 无 Dock 行为实测

- App 运行中（PID 36758）抓取主屏 Dock 条：`dock-with-app-running.png`——Dock 内仅 Finder/Chrome/微信/VLC 等既有项，**无 MDGrip 图块**（保留分隔线与废纸篓边界可对照）。
- 第二台显示器 Dock 区域：`dock-display2.png`（无 Dock 项无变化）。
- 辅证：`lsappinfo info -only ApplicationType MDGrip` 运行中返回 `type="UIElement"`；产物 `Info.plist` `LSUIElement=true` 未变——图标接入未引入 Dock 常驻。

## 5. Finder 实际观察（构建产物彩色 App 图标）

- `finder-app-icon.png`：Finder 图标视图显示 `MDGrip.app` 为**彩色蓝底 tile + 浅色页面 + 白窗**的成品图标（同屏 dSYM 占位文件可对照），不是通用白色应用图框。
- 操作：`open -R` 揭示 + 切换图标视图后截取 Finder 窗口区域。

## 6. 浅色菜单栏实测（多轮探测后达成）

三段式排查与最终达成，均如实记录：

1. **自适应玻璃的中间态（未达成浅色栏底，但证明 template 跟随栏面材质）**：浅色外观 + 纯白壁纸 + 6 秒稳定下，macOS 27.0.1 自适应菜单栏仍以暗色调玻璃渲染（栏面 luma 176，同帧系统时钟文字亦为白色——`menubar-light-clock-zoom.png`、`menubar-light-wide.png`，见 `menubar-dark-zoom.png` 为深色基线对照）。中途 `defaults write com.apple.universalaccess reduceTransparency` 写盘未实时生效，未采用脆弱的系统设置界面自动化补测，按原路放弃并以"降低透明度已还原 false"收束。
2. **达成实底浅色栏（最终证据）**：经系统设置「辅助功能 → 显示 → 降低透明度」复选框以 AXUI 真实点击开启（AppleScript 读值 0→1），配合浅色外观 + 白壁纸，菜单栏变为实底浅色（栏面 luma 215–234）；此时状态栏图形全部渲染为**黑色**。MDGrip 状态项（AppleScript 定位 `{1867,3}`、size `{36,24}`、description="MDGrip"，与像素簇位置吻合；相邻 VLC 圆锥约在 {1842,3}，经像素扫描复核避免 AX 坐标漂移误读）：
   - `menubar-light-solid.png`：整幅实底浅色栏原始带。
   - `menubar-light-solid-zoom.png`：图标链放大（圆锥/微信/MDGrip/播放器连续可对照）。
   - `menubar-light-solid-glyph-zoom.png`：**浅色栏底上的黑色"叠窗"图形特写**（页面折角 + 前窗块，清晰可辨）。
   - `popover-open-light-solid.png`：浅色模式下点按打开原面板的整体画面（顶部即实底浅色栏）。
   - 像素核验：图形区域 `min=32`（深色笔画）对栏面 `≈234`，对比显著。
3. **两种状态的 template 结论**：深色栏底 → 白色图形（luma 11 vs 白笔画 max 255）；浅色实底栏 → 黑色图形（min 32 vs 栏面 234）。template 着色由系统按栏面材质决定，两种状态实测均正确。

## 7. 用户设置还原

观察中临时改动均已还原并核实：桌面壁纸 Chroma Red.heic、外观深色（`dark mode = true`）、Reduce Transparency 经设置界面点击还原为 0、System Settings 已退出；观察中启动的 App 已退出（`pkill`）。

## 8. 变更清单（本票，无 Git 深度基线的观察清单）

- 新增：`macos/MDGrip/Assets.xcassets/Contents.json`、`AppIcon.appiconset/Contents.json`、`StatusBarIcon.imageset/Contents.json`（票 02 已交付 PNG，本票补目录描述并接入）。
- 修改：`macos/MDGrip.xcodeproj/project.pbxproj`（fileRef/group/Resources 阶段各一处，无其他设置变更）。
- 修改：`macos/MDGrip/AppDelegate.swift` `setupStatusItem()`（图像来源换为 `NSImage(named: "StatusBarIcon")` + 代码层 `accessibilityDescription`；保留 target/action；无系统符号回退/主题监听/状态机）。
- 本目录 14 个截图/放大证据文件（含浅色实底栏三件与浅色面板交互）。
- 未动：README、favicon、页脚模板、会话/Finder Services/预览逻辑；未 commit、未同步主 spec、未归档。

## 9. 未完成项（后续票据，与本票边界）

- 双架构 DMG 挂载资源检查、`/Applications` 目录观察与最终端到端验收：票据 07。
- README 图标（票 04）、浏览器 favicon（票 05）、页脚文案（票 06）。
- 本票不新增永久测试（要求自票据），`make macos-test` 既有套件保持绿色即回归底线。
