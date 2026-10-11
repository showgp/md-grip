# MDGrip

<img src="docs/brand/mdgrip.png" alt="MDGrip" width="96" />

Preview local Markdown files and documentation folders in your browser, with GitHub-style formatting.

- **MDGrip.app** is the native macOS menu bar app. Open files and folders from the app or Finder Services, manage running previews, and reopen recent targets. It includes the rendering tool; no Go installation or separate CLI is required.
- **`md-grip`** is the standalone Go-based CLI for macOS, Linux, and Windows, and the preview engine bundled with the app.

## Features

- Single-file previews and directory browsing, with optional recursive navigation.
- Searchable article sidebar, per-document table of contents, and previous/next navigation.
- Light and dark themes, syntax highlighting, Mermaid diagrams, and math expressions.
- Automatic reload on Markdown changes and in-browser editing with save-to-disk.
- HTML and PDF export from the preview toolbar. PDF export requires Chrome or Chromium installed locally.

## Install

### macOS app

Download a DMG from the [latest release](https://github.com/showgp/md-grip/releases/latest):

| Mac | Download |
| --- | --- |
| Apple Silicon | `MDGrip-arm64.dmg` |
| Intel | `MDGrip-x86_64.dmg` |

Open the DMG, drag `MDGrip.app` to Applications, and launch it. The app runs from the menu bar rather than the Dock.

> [!WARNING]
> The DMGs are candidate builds: ad-hoc signed, not Developer ID signed or notarized. macOS may require manual approval to open them. Clean-install trust verification is not complete.
> The build target is macOS 13+, but Intel and macOS 13 runtime validation remains pending; network-volume workflows are also unverified.

When upgrading, stop the app's previews and quit it before replacing it. Keep only one installed copy to avoid Finder opening a different copy.

### Standalone CLI

Download the archive for your OS and architecture from the [latest release](https://github.com/showgp/md-grip/releases/latest). CLI builds are provided for macOS (`darwin`), Linux, and Windows, each in `amd64` and `arm64` variants. Releases include `checksums.txt` for the CLI archives and both DMGs.

On macOS and Linux, extract the `.tar.gz` archive and run `./md-grip --help`. On Windows, extract the `.zip` archive and run `.\md-grip.exe --help`. Add the executable's directory to your `PATH` to use the commands below from anywhere.

Alternatively, with Go 1.26 or newer:

```sh
go install github.com/showgp/md-grip@latest
```

## Basic use

### macOS app

- Click the menu bar icon to open one or more Markdown files or folders.
- In Finder, select files or folders and choose **Services → Open with MDGrip** (**用 MDGrip 打开** on Simplified Chinese systems). The app does not need to be running beforehand.
- Use the panel to reopen a preview in your browser, copy its URL, stop it, or open a recent target.

If the Finder service is missing, check **System Settings → Keyboard → Keyboard Shortcuts → Services**. The panel's **Help** button reopens the Finder setup guide.

### CLI

```sh
md-grip README.md   # Preview one Markdown file
md-grip .           # Browse the current directory
md-grip -r docs     # Browse a directory and its nested Markdown files
md-grip --help      # Show available options
```

The CLI opens your browser automatically. Use `--browser=false` to disable that, `--no-reload` to disable automatic reload, and **Ctrl+C** to stop the server.

> [!NOTE]
> App-owned previews are restricted to loopback. The standalone CLI listens on all network interfaces; a `localhost` preview URL does not mean the server is loopback-only.

## Origin and license

MDGrip started as a fork of [chrishrb/go-grip](https://github.com/chrishrb/go-grip) and is now developed independently as `md-grip` / `MDGrip`.

The project and its original visual assets are [MIT licensed](LICENSE). The upstream copyright notice is retained, and bundled third-party assets retain their own licenses and notices.
