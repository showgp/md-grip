# MDGrip 品牌资产维护说明

**设计与导出分离**：本目录的四个 SVG 为可编辑源文件（用户选定方向 A「叠窗」），导出资产分置于各消费位置。正常构建直接消费已提交资产，不要求安装设计或导出工具；以下工具仅用于资产维护，不成为运行依赖。

- 渲染：`rsvg-convert 2.62.2`（macOS arm64）
- 拼装/ICO：`ImageMagick 7.1.2-29`

## 源文件与导出对应关系

| 源文件（本目录） | 场景 | 导出资产（消费位置） |
|---|---|---|
| `brand-mark.svg` | 仓库标记（简化平面） | `docs/brand/mdgrip.png`（512 × 512 透明 PNG，README 使用） |
| `app-icon.svg` | App 图标（蓝 tile 选项 B） | `macos/MDGrip/Assets.xcassets/AppIcon.appiconset/` 内 7 个 PNG（按 macOS 槽位命名，七种像素尺寸覆盖十个 1×/2× 槽位） |
| `status-bar.svg` | 状态栏（单色 template，黑 + alpha） | `macos/MDGrip/Assets.xcassets/StatusBarIcon.imageset/` 内 18 / 36 px 透明 PNG |
| `favicon.svg` | 浏览器标签 | `defaults/static/images/favicon.ico`（16 / 32 / 48 多尺寸 ICO，沿用现有嵌入路径） |

许可：图标与源文件沿用项目 MIT 许可（见仓库根 `LICENSE`），不引入独立图标许可或额外品牌使用限制。上游来源与已有版权说明保持不变。

## 导出命令（在仓库根目录执行）

```bash
set -e
mkdir -p macos/MDGrip/Assets.xcassets/AppIcon.appiconset \
         macos/MDGrip/Assets.xcassets/StatusBarIcon.imageset

rsvg-convert -w 16   -h 16   docs/brand/app-icon.svg   -o macos/MDGrip/Assets.xcassets/AppIcon.appiconset/icon_16x16.png
rsvg-convert -w 32   -h 32   docs/brand/app-icon.svg   -o macos/MDGrip/Assets.xcassets/AppIcon.appiconset/icon_16x16@2x.png
rsvg-convert -w 64   -h 64   docs/brand/app-icon.svg   -o macos/MDGrip/Assets.xcassets/AppIcon.appiconset/icon_32x32@2x.png
rsvg-convert -w 128  -h 128  docs/brand/app-icon.svg   -o macos/MDGrip/Assets.xcassets/AppIcon.appiconset/icon_128x128.png
rsvg-convert -w 256  -h 256  docs/brand/app-icon.svg   -o macos/MDGrip/Assets.xcassets/AppIcon.appiconset/icon_128x128@2x.png
rsvg-convert -w 512  -h 512  docs/brand/app-icon.svg   -o macos/MDGrip/Assets.xcassets/AppIcon.appiconset/icon_256x256@2x.png
rsvg-convert -w 1024 -h 1024 docs/brand/app-icon.svg   -o macos/MDGrip/Assets.xcassets/AppIcon.appiconset/icon_512x512@2x.png

rsvg-convert -w 18 -h 18 docs/brand/status-bar.svg -o macos/MDGrip/Assets.xcassets/StatusBarIcon.imageset/StatusBarIcon.png
rsvg-convert -w 36 -h 36 docs/brand/status-bar.svg -o macos/MDGrip/Assets.xcassets/StatusBarIcon.imageset/StatusBarIcon@2x.png

rsvg-convert -w 512 -h 512 docs/brand/brand-mark.svg -o docs/brand/mdgrip.png

rsvg-convert -w 16 -h 16 docs/brand/favicon.svg -o /tmp/mdgrip-favicon-16.png
rsvg-convert -w 32 -h 32 docs/brand/favicon.svg -o /tmp/mdgrip-favicon-32.png
rsvg-convert -w 48 -h 48 docs/brand/favicon.svg -o /tmp/mdgrip-favicon-48.png
magick /tmp/mdgrip-favicon-16.png /tmp/mdgrip-favicon-32.png /tmp/mdgrip-favicon-48.png defaults/static/images/favicon.ico
rm /tmp/mdgrip-favicon-16.png /tmp/mdgrip-favicon-32.png /tmp/mdgrip-favicon-48.png
```

核对导出结果：

```bash
magick identify docs/brand/mdgrip.png \
  macos/MDGrip/Assets.xcassets/AppIcon.appiconset/*.png \
  macos/MDGrip/Assets.xcassets/StatusBarIcon.imageset/*.png \
  defaults/static/images/favicon.ico
```

## 导出约定

- App 图标以七个唯一像素尺寸（16/32/64/128/256/512/1024）覆盖 macOS 16、32、128、256、512 pt 的十个 1×/2× 槽位，不重复保存相同像素尺寸的导出文件；资产目录描述文件（`Contents.json`）把同像素尺寸的槽位指向共用文件。
- 状态栏 PNG 以黑色 + alpha 表达单色图形，template 渲染形态由接入配置声明。
- favicon 临时 PNG 仅存于 `/tmp`，合成 ICO 后删除，不作为最终资产保留。
- 正常构建（Go embed / Xcode / Makefile）不调用以上命令，也不新增构建期导出步骤。
