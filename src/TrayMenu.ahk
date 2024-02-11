

Class TrayMenu extends Settings_Gui {
    TrayMenuObj := A_TrayMenu
    Saved_overTray := 0
    Tray_Profile_scwitch := 0

    TrayMenu() {
        Profiles_Submenu := Menu()

        for k in This.Profiles {
            If (k = This.LastUsedProfile) {
                Profiles_Submenu.Add(This.LastUsedProfile, MenuHandler)
                Profiles_Submenu.Check(This.LastUsedProfile)
            }
            Profiles_Submenu.Add(k, MenuHandler)
        }

        ;Profiles_Submenu.Add() ;*Seperator line

        TrayMenu := This.TrayMenuObj
        TrayMenu.Delete() ; Delete the Default TrayMenu Items

        TrayMenu.Add("Open", MenuHandler)
        TrayMenu.Add() ; Seperator
        TrayMenu.Add("Profiles", Profiles_Submenu)
        TrayMenu.Add() ; Seperator
        TrayMenu.Add("Suspend Hotkeys", MenuHandler)
        TrayMenu.Add()
        TrayMenu.Add()
        TrayMenu.Add("Close all EVE Clients", (*) => This.CloseAllEVEWindows())
        TrayMenu.Add()
        TrayMenu.Add()
        TrayMenu.Add("Restore Client Positions", MenuHandler)
        if (This.TrackClientPossitions)
            TrayMenu.check("Restore Client Positions")
        else
            TrayMenu.Uncheck("Restore Client Positions")

        TrayMenu.Add("Save Client Positions", (*) => This.Client_Possitions())
        TrayMenu.Add()
        TrayMenu.Add()
        TrayMenu.Add("Save Thumbnail Positions", MenuHandler)  ; Creates a separator line.
        TrayMenu.Add("Reload", (*) => Reload())
        TrayMenu.Add()
        TrayMenu.Add("Exit", (*) => ExitApp())  ; Creates a new menu item.
        TrayMenu.Default := "Open"

        MenuHandler(ItemName, ItemPos, MyMenu) {
            If (ItemName = "Exit")
                ExitApp
            Else if (ItemName = "Save Thumbnail Positions") {
                ;* Saved Thumbnail Positions only if the Saved button is used on the Traymenu
                This.Save_ThumbnailPossitions
            }
            Else if (ItemName = "Restore Client Positions") {
                This.TrackClientPossitions := !This.TrackClientPossitions
                TrayMenu.ToggleCheck("Restore Client Positions")
                SetTimer(This.Save_Settings_Delay_Timer, -200)
            }
            Else if (This.Profiles.Has(ItemName)) {
                This.Tray_Profile_scwitch := 1
                This.LastUsedProfile := ItemName
                This.Save_Settings()
                This.Tray_Profile_scwitch := 0
                Reload()
            }
            Else if (ItemName = "Open") {
                if WinExist("EVE-X-Preview - Settings") {
                    WinActivate("EVE-X-Preview - Settings")
                    Return
                }
                This.MainGui()
            }
            Else If (ItemName = "Suspend Hotkeys") {
                Suspend(-1)
                TrayMenu.ToggleCheck("Suspend Hotkeys")
            }

        }
    }

    CloseAllEVEWindows(*) {
        try {
            list := WinGetList("Ahk_Exe exefile.exe")
            GroupAdd("EVE", "Ahk_Exe exefile.exe")
            for k in list {
                PostMessage 0x0112, 0xF060, , , k
                Sleep(50)
            }
        }
    }
}
