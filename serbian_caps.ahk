#Requires AutoHotkey v2.0

SerbMode := false
DoubleTapThreshold := 400

; При старте: CapsLock всегда выкл, ScrollLock выкл
SetCapsLockState "Off"
SetScrollLockState "Off"

; CapsLock = переключатель сербского режима
; ЛАМПОЧКА режима – ScrollLock
CapsLock:: {
    global SerbMode
    SerbMode := !SerbMode

    ; не даём системному CapsLock включаться (чтобы не ломал регистр)
    SetCapsLockState "Off"

    ; включаем/выключаем лампочку ScrollLock как индикатор режима
    SetScrollLockState(SerbMode ? "On" : "Off")
}

; --- ВЫБОР РЕГИСТРА ТОЛЬКО ПО SHIFT ---
SendSerbLetter(lower, upper) {
    if GetKeyState("Shift", "P")
        Send upper
    else
        Send lower
}

SendNormalKey(key) {
    ; просто пробрасываем физическую клавишу, с учётом Ctrl/Shift/Alt
    Send "{Blind}{" key "}"
}

HasModifierKeys() {
    return GetKeyState("Ctrl","P") || GetKeyState("Alt","P")
        || GetKeyState("LWin","P") || GetKeyState("RWin","P")
}

GetKeyboardLayout() {
    threadId := DllCall("GetWindowThreadProcessId", "UInt", WinExist("A"), "UInt", 0)
    hkl := DllCall("GetKeyboardLayout", "UInt", threadId, "Ptr")
    return hkl & 0xFFFF
}

IsRussianLayout() {
    return GetKeyboardLayout() = 0x0419
}

IsEnglishLayout() {
    layout := GetKeyboardLayout()
    return layout = 0x0409 || layout = 0x0809
}

; Й → ј / Ј (сербская кириллица!)
$*q:: {
    if !SerbMode || HasModifierKeys() || !IsRussianLayout()
        return SendNormalKey("q")
    SendSerbLetter("ј", "Ј")
}

; Л → љ / Љ (двойное нажатие)
$*k:: {  ; k = Л в русской, K в английской
    global SerbMode, DoubleTapThreshold
    static lastTime := 0
    static sentKey := false
    
    if !SerbMode || HasModifierKeys() {
        SendNormalKey("k")
        lastTime := 0
        sentKey := false
        return
    }
    
    if IsRussianLayout() {
        t := A_TickCount
        if (t - lastTime <= DoubleTapThreshold && sentKey) {
            Send "{BS}"
            SendSerbLetter("љ", "Љ")
            lastTime := 0
            sentKey := false
        } else {
            SendNormalKey("k")
            lastTime := t
            sentKey := true
        }
    } else {
        SendNormalKey("k")
        lastTime := 0
        sentKey := false
    }
}

; Н → њ / Њ (двойное нажатие)
$*y:: {  ; y = Н в русской, Y в английской
    global SerbMode, DoubleTapThreshold
    static lastTime := 0
    static sentKey := false
    
    if !SerbMode || HasModifierKeys() {
        SendNormalKey("y")
        lastTime := 0
        sentKey := false
        return
    }
    
    if IsRussianLayout() {
        t := A_TickCount
        if (t - lastTime <= DoubleTapThreshold && sentKey) {
            Send "{BS}"
            SendSerbLetter("њ", "Њ")
            lastTime := 0
            sentKey := false
        } else {
            SendNormalKey("y")
            lastTime := t
            sentKey := true
        }
    } else {
        SendNormalKey("y")
        lastTime := 0
        sentKey := false
    }
}

; Ж → ж / Ж, двойное Ж → Џ / Џ
$*vkBA:: {  ; vkBA = ; в EN / Ж в RU
    global SerbMode, DoubleTapThreshold
    static lastTime := 0
    static sentKey := false

    if !SerbMode || HasModifierKeys() {
        SendNormalKey("vkBA")
        lastTime := 0
        sentKey := false
        return
    }

    if IsRussianLayout() {
        t := A_TickCount
        if (t - lastTime <= DoubleTapThreshold && sentKey) {
            Send "{BS}"
            SendSerbLetter("џ", "Џ")
            lastTime := 0
            sentKey := false
        } else {
            SendSerbLetter("ж", "Ж")
            lastTime := t
            sentKey := true
        }
    } else {
        SendNormalKey("vkBA")
        lastTime := 0
        sentKey := false
    }
}

; Ч → ч / Ч, двойное → ћ / Ћ
$*x:: {  ; x = Ч в русской, X в английской
    global SerbMode, DoubleTapThreshold
    static lastTime := 0
    static sentCh := false
    
    if !SerbMode || HasModifierKeys() {
        SendNormalKey("x")
        lastTime := 0
        sentCh := false
        return
    }
    
    if IsRussianLayout() {
        t := A_TickCount
        if (t - lastTime <= DoubleTapThreshold && sentCh) {
            Send "{BS}"
            SendSerbLetter("ћ", "Ћ")
            lastTime := 0
            sentCh := false
        } else {
            SendNormalKey("x")
            lastTime := t
            sentCh := true
        }
    } else {
        SendNormalKey("x")
        lastTime := 0
        sentCh := false
    }
}

; Д → д / Д, двойное → ђ / Ђ
$*l:: {  ; l = Д в русской, L в английской
    global SerbMode, DoubleTapThreshold
    static lastTime := 0
    static sentKey := false
    
    if !SerbMode || HasModifierKeys() {
        SendNormalKey("l")
        lastTime := 0
        sentKey := false
        return
    }
    
    if IsRussianLayout() {
        t := A_TickCount
        if (t - lastTime <= DoubleTapThreshold && sentKey) {
            Send "{BS}"
            SendSerbLetter("ђ", "Ђ")
            lastTime := 0
            sentKey := false
        } else {
            SendNormalKey("l")
            lastTime := t
            sentKey := true
        }
    } else {
        SendNormalKey("l")
        lastTime := 0
        sentKey := false
    }
}

; C (EN) / С (RU)
; RU: просто С, EN: C → c → ć → č
$*c:: {  ; c = C в английской, С в русской
    global SerbMode, DoubleTapThreshold
    static lastTime := 0
    static pressCount := 0
    
    if !SerbMode || HasModifierKeys() {
        SendNormalKey("c")
        lastTime := 0
        pressCount := 0
        return
    }
    
    if IsRussianLayout() {
        SendNormalKey("c")
        lastTime := 0
        pressCount := 0
    } else if (IsEnglishLayout()) {
        t := A_TickCount
        if (t - lastTime > DoubleTapThreshold) {
            pressCount := 1
            lastTime := t
            SendSerbLetter("c", "C")
        } else {
            pressCount++
            lastTime := t
            
            if (pressCount = 2) {
                Send "{BS}"
                SendSerbLetter("ć", "Ć")
            } else if (pressCount = 3) {
                Send "{BS}"
                SendSerbLetter("č", "Č")
                pressCount := 0
            }
        }
    } else {
        SendNormalKey("c")
    }
}

; S (EN) / Ы (RU)
; RU: обычная Ы, EN: s → s → š
$*s:: {  ; s = S в английской, Ы в русской
    global SerbMode, DoubleTapThreshold
    static lastTime := 0
    static sentS := false
    
    if !SerbMode || HasModifierKeys() {
        SendNormalKey("s")
        lastTime := 0
        sentS := false
        return
    }
    
    if IsRussianLayout() {
        SendNormalKey("s")
        lastTime := 0
        sentS := false
    } else if (IsEnglishLayout()) {
        t := A_TickCount
        if (t - lastTime <= DoubleTapThreshold && sentS) {
            Send "{BS}"
            SendSerbLetter("š", "Š")
            lastTime := 0
            sentS := false
        } else {
            SendNormalKey("s")
            lastTime := t
            sentS := true
        }
    } else {
        SendNormalKey("s")
    }
}

; Z (EN) / З (RU)
; RU: обычная З, EN: z → z → ž
$*z:: {  ; z = Z в английской, З в русской
    global SerbMode, DoubleTapThreshold
    static lastTime := 0
    static sentZ := false
    
    if !SerbMode || HasModifierKeys() {
        SendNormalKey("z")
        lastTime := 0
        sentZ := false
        return
    }
    
    if IsRussianLayout() {
        SendNormalKey("z")
        lastTime := 0
        sentZ := false
    } else if (IsEnglishLayout()) {
        t := A_TickCount
        if (t - lastTime <= DoubleTapThreshold && sentZ) {
            Send "{BS}"
            SendSerbLetter("ž", "Ž")
            lastTime := 0
            sentZ := false
        } else {
            SendNormalKey("z")
            lastTime := t
            sentZ := true
        }
    } else {
        SendNormalKey("z")
    }
}

; D (EN) / В (RU)
; RU: обычная В, EN: d → d → đ
$*d:: {  ; d = D в английской, В в русской
    global SerbMode, DoubleTapThreshold
    static lastTime := 0
    static sentD := false
    
    if !SerbMode || HasModifierKeys() {
        SendNormalKey("d")
        lastTime := 0
        sentD := false
        return
    }
    
    if IsRussianLayout() {
        SendNormalKey("d")
        lastTime := 0
        sentD := false
    } else if (IsEnglishLayout()) {
        t := A_TickCount
        if (t - lastTime <= DoubleTapThreshold && sentD) {
            Send "{BS}"
            SendSerbLetter("đ", "Đ")
            lastTime := 0
            sentD := false
        } else {
            SendNormalKey("d")
            lastTime := t
            sentD := true
        }
    } else {
        SendNormalKey("d")
    }
}
