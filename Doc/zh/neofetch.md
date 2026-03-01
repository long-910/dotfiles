# neofetch

以 ASCII 艺术形式显示系统信息的工具。

---

## 使用方法

```bash
neofetch
```

打开新终端或进入新环境时运行，可快速查看操作系统、内核、CPU、内存等系统信息。

---

## 显示内容

| 字段 | 内容 |
|------|------|
| OS | 发行版名称及版本 |
| Host | 主机名与机器型号 |
| Kernel | 内核版本 |
| Uptime | 系统运行时间 |
| Packages | 已安装软件包数量 |
| Shell | 当前 Shell 及其版本 |
| Resolution | 屏幕分辨率（有桌面环境时显示） |
| DE / WM | 桌面环境 / 窗口管理器 |
| Terminal | 终端模拟器 |
| CPU | 处理器名称及核心数 |
| GPU | 显卡（可检测时显示） |
| Memory | 已用内存 / 总内存 |

---

## 常用选项

```bash
neofetch --off            # 仅显示信息，不显示 ASCII 艺术
neofetch --ascii_distro ubuntu  # 使用其他发行版的 ASCII 艺术
neofetch --config none    # 忽略配置文件运行
```

---

## 配置文件

在 `~/.config/neofetch/config.conf` 中自定义显示项目、颜色和 ASCII 艺术。

```bash
# 生成配置文件（首次使用）
neofetch --config ~/.config/neofetch/config.conf
```

主要设置：
- 注释掉 `info` 行可隐藏对应字段
- 修改 `image_backend` 可使用图片替代 ASCII 艺术（需要 kitty / iTerm2 / WezTerm 等支持的终端）
- 通过 `colors` 自定义配色

---

## WSL 注意事项

在 WSL2 上，GPU 信息和屏幕分辨率可能无法正确获取。
使用 `neofetch --off` 可稳定显示信息部分。
