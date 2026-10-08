# AudioBridge — 手机音频桥

把手机声音送到电脑播放的跨平台一键工具。

- **Windows 10 2004+ / Windows 11**：电脑作为 Bluetooth A2DP Sink，手机通过蓝牙把声音送到电脑。
- **macOS 12+**：使用系统自带的 AirPlay Receiver，把 iPhone / iPad 的声音送到 Mac。

> 两个平台底层机制不同。Windows 有公开的 `AudioPlaybackConnection` A2DP Sink 能力；macOS 没有给普通应用提供同等的蓝牙 A2DP Sink 接口，因此 Mac 端使用 Apple 官方支持的 AirPlay Receiver，而不是伪装成“蓝牙接收”。

## Windows

### 使用

1. 在「设置 → 蓝牙和设备」里先把手机与电脑配对。
2. 下载 Release 里的 `AudioBridge-win.zip` 并解压，双击 `AudioBridge/windows/Start.cmd`。
3. 第一次运行会自动从 `Dearkoma/AudioPlaybackConnector` 的 GitHub Release 下载与系统匹配的组件。
4. 下载后根据 GitHub Release 提供的 SHA-256 digest 自动校验，校验通过才启动。
5. 点击 Windows 通知区域里的 AudioPlaybackConnector 图标，选择手机并连接。
6. 在手机上播放声音。

运行组件会缓存到：

```text
%LOCALAPPDATA%\BluetoothPhoneAudio-OneClick
```

以后双击 `Start.cmd` 会先检查是否有新版，再启动。

### 两台手机

底层连接器可以维护多个 A2DP 连接，但多个设备会共享同一个蓝牙无线链路和 Windows 音频路径，稳定性取决于蓝牙适配器、驱动、2.4 GHz 干扰和手机端行为。出现“已连接但没声音”时，先对对应设备点一次「重连」。

### Windows 诊断

PowerShell 运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\windows\Diagnose.ps1
```

## macOS

Mac 端不安装第三方音频驱动，直接调用系统 AirPlay Receiver。

### 使用

1. 下载并解压 Release 里的 `AudioBridge-mac-universal.zip`，双击其中的 `AudioBridge.app`。
2. 点「打开 AirPlay 设置」。
3. 在 Mac 系统设置中打开 **AirPlay Receiver**。
4. 在 iPhone / iPad 上播放声音，打开控制中心。
5. 在音频输出 / AirPlay 菜单里选择这台 Mac。

Apple 官方支持把 iPhone、iPad 或另一台 Mac 的音频通过 AirPlay 播放到 Mac。

### macOS 限制

- 这里不是 Bluetooth A2DP Sink。
- 主要面向 iPhone / iPad / 其他支持 AirPlay 的发送端。
- Android 如果没有支持 AirPlay 输出的发送端应用，不能靠这个项目直接把系统声音投到 Mac。
- AirPlay 通常要求两台设备处在兼容的网络环境中；同一 Apple Account 使用起来最顺畅。

## 安全与供应链

Windows 启动器只从：

`https://github.com/Dearkoma/AudioPlaybackConnector`

获取最新版 release，并优先使用 GitHub API 返回的 SHA-256 digest 验证下载文件。底层项目为 MIT License。

## 构建 Release

打 `v*` tag 后，GitHub Actions 会生成：

- `AudioBridge-win.zip`
- `AudioBridge-mac-universal.zip`
- `SHA256SUMS.txt`

## License

本仓库自有脚本：MIT。

Windows 端依赖的 `AudioPlaybackConnector`：MIT，版权归其原作者/贡献者所有，详见 `THIRD_PARTY_NOTICES.md`。
