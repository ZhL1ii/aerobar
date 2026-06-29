**AeroBar** is a maintained fork of [**barik**](https://github.com/mocki-toki/barik), originally created by [**Simon Butenko**](https://github.com/mocki-toki). The upstream project has been quiet for a while, so this fork exists to fix long-standing issues, keep the project usable, and continue improving the macOS menu bar experience.

----

<p align="center" dir="auto">
  <img src="resources/header-image.png" alt="AeroBar">
  <p align="center" dir="auto">
    <a href="LICENSE">
      <img alt="License Badge" src="https://img.shields.io/badge/license-MIT-green.svg" style="max-width: 100%;">
    </a>
    <a href="CHANGELOG.md">
      <img alt="Changelog Badge" src="https://img.shields.io/badge/view-changelog-green.svg" style="max-width: 100%;">
    </a>
    <a href="https://github.com/mocki-toki/barik">
      <img alt="Upstream Badge" src="https://img.shields.io/badge/upstream-barik-green.svg" style="max-width: 100%;">
    </a>
  </p>
</p>

**AeroBar** is a lightweight macOS menu bar replacement based on **barik**. If you use [**yabai**](https://github.com/koekeishiya/yabai) or [**AeroSpace**](https://github.com/nikitabobko/AeroSpace) for tiling WM, you can display the current space in a sleek macOS-style panel with smooth animations. This makes it easy to see which number to press to switch spaces.

This fork will stay close to the original idea while improving stability, configuration, update behavior, and day-to-day usability.

<br>

<div align="center">
  <h3>Screenshots</h3>
  <img src="resources/preview-image-light.png" alt="AeroBar Light Theme">
  <img src="resources/preview-image-dark.png" alt="AeroBar Dark Theme">
</div>
<br>
<div align="center">
  <h3>Video</h3>
  <video src="https://github.com/user-attachments/assets/33cfd2c2-e961-4d04-8012-664db0113d4f">
</div>
    
https://github.com/user-attachments/assets/d3799e24-c077-4c6a-a7da-a1f2eee1a07f

<br>

## Requirements

- macOS 14.6+

## Quick Start

1. Download the latest build from this repository's Releases page, unzip it, and move it to your Applications folder.

2. _(Optional)_ To display open applications and spaces, install [**yabai**](https://github.com/koekeishiya/yabai) or [**AeroSpace**](https://github.com/nikitabobko/AeroSpace) and set up hotkeys. For **yabai**, you'll need **skhd** or **Raycast scripts**. Don't forget to configure **top padding** — [here's an example for **yabai**](example/.yabairc).

3. Hide the system menu bar in **System Settings** and uncheck **Desktop & Dock → Show items → On Desktop**.

4. Launch **AeroBar** from the Applications folder.

5. Add **AeroBar** to your login items for automatic startup.

**That's it!** Try switching spaces and see the panel in action.

## Configuration

When you launch **AeroBar** for the first time, it will create a config file with an example customization for your new menu bar. The project is still in a rename transition, so current builds may still use the original `~/.barik-config.toml` path.

```toml
# If you installed yabai or aerospace without using Homebrew,
# manually set the path to the binary. For example:
#
# yabai.path = "/run/current-system/sw/bin/yabai"
# aerospace.path = ...

theme = "system" # system, light, dark

[widgets]
displayed = [ # widgets on menu bar
    "default.spaces",
    "spacer",
    "default.nowplaying",
    "default.network",
    "default.battery",
    "divider",
    # { "default.time" = { time-zone = "America/Los_Angeles", format = "E d, hh:mm" } },
    "default.time",
]

[widgets.default.spaces]
space.show-key = true        # show space number (or character, if you use AeroSpace)
window.show-title = true
window.title.max-length = 50

# A list of applications that will always be displayed by application name.
# Other applications will show the window title if there is more than one window.
window.title.always-display-app-name-for = ["Mail", "Chrome", "Arc"]

[widgets.default.nowplaying.popup]
view-variant = "horizontal"

[widgets.default.battery]
show-percentage = true
warning-level = 30
critical-level = 10

[widgets.default.time]
format = "E d, J:mm"
calendar.format = "J:mm"

calendar.show-events = true
# calendar.allow-list = ["Home", "Personal"] # show only these calendars
# calendar.deny-list = ["Work", "Boss"] # show all calendars except these

[widgets.default.time.popup]
view-variant = "box"



### EXPERIMENTAL, WILL BE REPLACED BY STYLE API IN THE FUTURE
[experimental.background] # settings for blurred background
displayed = false         # display blurred background
height = "menu-bar"       # available values: default (stretch to full screen), menu-bar (height like system menu bar), <float> (e.g., 40, 33.5)
blur = 3                  # background type: from 1 to 6 for blur intensity, 7 for black color

[experimental.foreground] # settings for menu bar
height = "menu-bar"       # available values: default (55.0), menu-bar (height like system menu bar), <float> (e.g., 40, 33.5)
horizontal-padding = 25   # padding on the left and right corners
spacing = 15              # spacing between widgets

[experimental.foreground.widgets-background] # settings for widgets background
displayed = false                            # wrap widgets in their own background
blur = 3                                     # background type: from 1 to 6 for blur intensity
```

Currently, you can customize the order of widgets (time, indicators, etc.) and adjust some of their settings. Future versions will continue expanding appearance customization, widget behavior, and integration quality.

## Future Plans

This fork will focus first on reliability, project identity cleanup, and a smoother configuration experience. After that, the roadmap includes full style customization, the ability to create custom widgets or extend existing ones, and better support for sharing styles and widgets.

Longer term, widgets should be flexible enough to live beyond the top menu bar, including bottom, left, and right screen edges.

## What to do if the currently playing song is not displayed in the Now Playing widget?

Unfortunately, macOS does not support access to its API that allows music control. Fortunately, there is a workaround using Apple Script or a service API, but this requires additional work to integrate each service. Currently, the Now Playing widget supports the following services:

1. Spotify (requires the desktop application)
2. Apple Music (requires the desktop application)

Create an issue so we can consider adding your favorite music service.

## Where Are the Menu Items?

Originally tracked upstream in [#5](https://github.com/mocki-toki/barik/issues/5) and [#1](https://github.com/mocki-toki/barik/issues/1).

Menu items (such as File, Edit, View, etc.) are not currently supported, but they are planned for future releases. However, you can use [Raycast](https://www.raycast.com/), which supports menu items through an interface similar to Spotlight. I personally use it with the `option + tab` shortcut, and it works very well.

If you’re accustomed to using menu items from the system menu bar, simply move your mouse to the top of the screen to reveal the system menu bar, where they will be available.

<img src="resources/raycast-menu-items.jpeg" alt="Raycast Menu Items">

## Contributing

Contributions are welcome. This fork is intended to keep the original idea moving forward while giving proper credit to the upstream project.

## License

[MIT](LICENSE)

This project is based on [**barik**](https://github.com/mocki-toki/barik) by [**Simon Butenko**](https://github.com/mocki-toki). See [LICENSE](LICENSE) for the original MIT license notice.

## Trademarks

Apple and macOS are trademarks of Apple Inc. This project is not connected to Apple Inc. and does not have their approval or support.

## Upstream

Original project: [mocki-toki/barik](https://github.com/mocki-toki/barik)
