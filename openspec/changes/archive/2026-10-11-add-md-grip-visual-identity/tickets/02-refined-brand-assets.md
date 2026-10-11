# 02: 用户选定方向的四类成品资产交付

Status: done
Blocked by: 01-low-fidelity-candidates
Covers OpenSpec tasks: 1.2, 2.1, 2.2
Behavior source: ../specs/project-visual-identity/spec.md
Design source: ../design.md
Task source: ../tasks.md

## Deliverable

沿用户选定方向交付可直接查看、编辑和重新导出的四类品牌资产包，包含 SVG、各消费位置的 PNG/ICO 与维护说明。它是可独立评审的设计交付，不将资产文件存在表述为 App、README 或浏览器已经完成接入验收。

## Context

- 覆盖 `Shared original visual identity` 的 `Recognize the identity across surfaces`、`Deliver an independent original identity`；覆盖 `User selection precedes refinement and integration` 的 `Refine the selected direction`；完成 `Editable MIT-licensed asset delivery` 的 `Maintain the visual assets`。构建不依赖导出工具的实际验证仍由接入及最终验收票共同完成。
- 使用 design Decisions 1、2、4 和 Decisions 3 中的尺寸布局；源文件与导出资产位置按 design，不另建资产生成框架。
- 除票据 01 的候选交付外，还必须取得用户实际选择；缺少选择时停止，不用默认推荐代替任务 1.2。精修具体色值和展示意见也需用户确认，未确认不导出最终资产。
- 生成最终 favicon 到现有嵌入路径会随后续构建进入产品；浏览器实际标签验收由票据 05 完成，不能据此提前关闭该票或任务 3.3。

## Acceptance

- [x] 记录可追溯的用户选择及意见，再沿选定方向精修；四类版本同时展示供用户评审并确认具体色值及精修意见，不制作另一个未选定方向的最终方案。
- [x] 交付 design 指定的四个可编辑 SVG；实际渲染并观察同源核心轮廓和场景适配，图标无文字，来源原创且不含外部字体或链接素材依赖。
- [x] 交付 App 所需 16/32/64/128/256/512/1024 px PNG、状态栏 18/36 px 透明 PNG、仓库 512 px 透明 PNG，以及含 16/32/48 px 的 favicon.ico；检查实际尺寸、透明度和小尺寸识别效果，不重复保存相同像素尺寸的 App 导出文件。
- [x] 同票交付简短维护说明，包含源文件对应关系、工具版本、直接导出命令和沿用项目 MIT 的说明；实际执行说明中的命令，确认能得到所需导出资产，不只复制未运行命令。
- [x] 不增加构建时导出步骤、独立许可或专有工程文件；保持上游来源和已有版权说明。临时导出文件不作为最终资产包保留。
- [x] 记录资产评审与导出证据，明确模拟展示与真实接入的区别；本票不完成任务 3.1、3.2、3.3 或最终视觉验收，不为资源引用或源文件文字新增永久测试。

## Closure record

交付物：`docs/brand/` 四个可编辑源（`brand-mark.svg` / `app-icon.svg` / `status-bar.svg` / `favicon.svg`，用户选定方向 A「叠窗」，同构单轮廓构造）+ `mdgrip.png`（512 透明）+ `README.md`（源文件映射、工具版本 rsvg-convert 2.62.2 / ImageMagick 7.1.2-29、直接导出命令与 MIT 说明）；`macos/MDGrip/Assets.xcassets/AppIcon.appiconset/` 7 个唯一像素尺寸 PNG（16/32/64/128/256/512/1024，无同尺寸副本；**不含 Contents.json**——目录描述与 target 接入属票据 03）；`StatusBarIcon.imageset/` 18/36 px 透明 PNG；`defaults/static/images/favicon.ico` 替换为 16/32/48 三帧 ICO（tracked 修改；模板 link、embed、路由均未动）。

选择与精修确认：`../reviews/selection.md`（"选 A"；蓝 `#3E6E9E`；App tile 选项 B 蓝底；"按现状导出"）；阶段一评审与像素级观察（缝隙/留白探针、镂空环"垫板"缺陷修正、单轮廓统一构造）及导出核对记录见 `../reviews/refined/`。

维护命令按 `docs/brand/README.md` 原样执行成功；`magick identify` 实测尺寸/三帧/alpha 与维护说明一致；48 px ICO 帧与 512 px App 导出实际放大观察辨认清楚。

独立审查：Standards 与 Spec 两轴独立进行，均 PASS（各 0 blocking、0 advisory、0 未决范围决策）；两轴均声明覆盖限制（未重跑导出/统计命令、未独立访问选择会话、真实界面验收不在本票范围）。

变更清单：上述新增与替换条目；另有与本票无关的既有用户改动保留（`.agents/skills/tasks-to-tickets/SKILL.md`、`AGENTS.md`）。未 commit、未同步主 spec、未归档。
