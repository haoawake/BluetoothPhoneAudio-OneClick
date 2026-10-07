on run
    set msg to "Mac 端使用 Apple 原生 AirPlay Receiver 接收 iPhone / iPad 的声音。\n\n注意：macOS 没有向普通应用公开与 Windows AudioPlaybackConnection 等价的 Bluetooth A2DP Sink 接口，所以这里不会假装成蓝牙音箱。"
    display dialog msg with title "AudioBridge" buttons {"取消", "打开 AirPlay 设置"} default button "打开 AirPlay 设置" with icon note
    if button returned of result is "打开 AirPlay 设置" then
        my openAirPlaySettings()
        delay 0.8
        display dialog "把「AirPlay Receiver」打开。\n\n然后在 iPhone / iPad：\n1. 播放任意音频\n2. 打开控制中心\n3. 点 AirPlay / 音频输出按钮\n4. 选择这台 Mac\n\n之后声音就会从 Mac 当前扬声器或耳机播放。" with title "下一步" buttons {"知道了"} default button "知道了" with icon note
    end if
end run

on openAirPlaySettings()
    try
        set majorVersion to word 1 of (do shell script "sw_vers -productVersion | cut -d. -f1") as integer
        if majorVersion is greater than or equal to 13 then
            do shell script "open 'x-apple.systempreferences:com.apple.AirDrop-Handoff-Settings.extension'"
        else
            do shell script "open 'x-apple.systempreferences:com.apple.preference.sharing'"
        end if
    on error
        try
            tell application "System Settings" to activate
        on error
            tell application "System Preferences" to activate
        end try
    end try
end openAirPlaySettings
