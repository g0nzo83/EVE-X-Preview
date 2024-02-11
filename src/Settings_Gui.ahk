Class Settings_Gui {
    MainGui() {
        ;if settings got chnaged which require a restart to apply
        This.NeedRestart := 0


        ;MsgBox(This.CustomColorsGet["Example Char"]["Char"])

        SetControlDelay(-1)
        This.S_Gui := Gui("+OwnDialogs +MinimizeBox -Resize -MaximizeBox -DPIScale SysMenu +MinSize500x250")
        This.S_Gui.Title := "EVE-X-Preview - Settings"

        ;Font options for the Buttons
        This.S_Gui.SetFont("s10 w700")

        ;Sets Margins for the following Buttons
        This.S_Gui.MarginX := 80, This.S_Gui.MarginY := 20
        This.S_Gui.Add("Button", " x140 y20 w120 h40 vGlobal_Settings", "Global Settings").OnEvent("Click", (obj, *) => Button_Handler(obj))
        This.S_Gui.Add("Button", "x+40 y+-40 wp hp vProfile_Settings", "Profile Settings").OnEvent("Click", (obj, *) => Button_Handler(obj))

        This.S_Gui.Show("hide")

        ;Create the Arrays which hold the GUI objects for the controls
        This.S_Gui.Controls := [], This.S_Gui.ClientSettings := []

        ;Sets Margins for the following controls
        This.S_Gui.MarginX := 25

        ;Default Font options for the controls
        This.S_Gui.SetFont("s9 w400")
        ;Creates the Controls
        This.Global_Settings(), This.Profile_Settings(), This.ClientSettings_Ctrl(), This.Custom_ColorsCtrl()
        This.Hotkey_GroupsCtrl(), This.HotkeysCtrl(), This.ThumbnailSettings_Ctrl(), This.Thumbnail_visibilityCtrl()

        This.S_Gui.Show("AutoSize Center")
        This._Button_Load()

        This.Seetings_DDL.OnEvent("Change", (Obj, *) => SettingsDDL_Handler(Obj))

        This.S_Gui.OnEvent("Close", (*) => GuiDestroy())

        GuiDestroy(*) {
            This.S_Gui.Destroy()
            if (This.NeedRestart)
                Reload()
        }

        SettingsDDL_Handler(Obj) {
            for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL {
                if k = Obj.Text {
                    for _, ob in v
                        ob.Visible := 1
                }
                else {
                    for _, ob in v
                        ob.Visible := 0
                }
            }
            This.S_Gui.Show("AutoSize")
        }

        Button_Handler(obj) {
            if (obj.Name = "Global_Settings") {
                for ButtonName, Controls in This.S_Gui.Controls.OwnProps() {
                    if ButtonName = obj.Name {
                        for _, Ctrl in Controls {
                            Ctrl.Visible := 1
                        }
                    }
                    else {
                        for _, Ctrl in Controls {
                            Ctrl.Visible := 0
                        }
                        for _, Ctrl in This.S_Gui.Controls.Profile_Settings.PsDDL {
                            for k, v in Ctrl
                                v.Visible := 0
                        }

                    }
                }
            }
            else if (obj.Name = "Profile_Settings") {
                for ButtonName, Controls in This.S_Gui.Controls.OwnProps() {
                    if ButtonName = obj.Name {
                        for _, Ctrl in Controls {
                            Ctrl.Visible := 1
                        }
                        for _, Ctrl in This.S_Gui.Controls.Profile_Settings.PsDDL {
                            if (This.Seetings_DDL.Text = _) {
                                for k, v in Ctrl {
                                    v.Visible := 1
                                }
                            }
                        }
                    }
                    else {
                        for _, Ctrl in Controls {
                            Ctrl.Visible := 0
                        }
                    }
                }
                if (This.Profiles.Count = 1 && This.SelectProfile_DDL.Text = "Default")
                    MsgBox("you must first create a profile to change the settings")
            }

            This.S_Gui.Show("AutoSize")


        }
    }

    ;This Function creates all Settings controls for the Global Settings Button
    Global_Settings(visible?) {
        This.S_Gui.Controls.Global_Settings := []
        This.S_Gui.SetFont("s10 w400")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("GroupBox", "x20 y80 h280 w500")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xp+15 yp+20 Section", "Suspend Hotkeys - Hotkey:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", "Hotkey activation Scope:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", "Thumbnail Background Color:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", "Thumbnail Default Location:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", "Thumbnail Minimum Size:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", "Thumbnail Snap:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", "Thumbnail Snap Distance:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", "Minimize EVE Window Delay:")

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "xs+230 ys-3 w150 Section vSuspend_Hotkeys_Hotkey", This.Suspend_Hotkeys_Hotkey)
        This.S_Gui["Suspend_Hotkeys_Hotkey"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("DDL", "xp y+5 w180 vTTT vHotkey_Scoope Choose" (This.Global_Hotkeys ? 1 : 2), ["Global", "If an EVE window is Active"])
        This.S_Gui["Hotkey_Scoope"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "xp y+5 w120 section vThumbnailBackgroundColor", This.ThumbnailBackgroundColor)
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xp+130 yp+4", "Hex or RGB")
        This.S_Gui["ThumbnailBackgroundColor"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs+2 y+17 section", "x:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailStartLocationx", This.ThumbnailStartLocation["x"])
        This.S_Gui["ThumbnailStartLocationx"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "x+8 ys ", "y:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailStartLocationy", This.ThumbnailStartLocation["y"])
        This.S_Gui["ThumbnailStartLocationy"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "x+8 ys ", "w:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailStartLocationwidth", This.ThumbnailStartLocation["width"])
        This.S_Gui["ThumbnailStartLocationwidth"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "x+8 ys ", "h:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailStartLocationheight", This.ThumbnailStartLocation["height"])
        This.S_Gui["ThumbnailStartLocationheight"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+10 section ", "width:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailMinimumSizewidth", This.ThumbnailMinimumSize["width"])
        This.S_Gui["ThumbnailMinimumSizewidth"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "x+8 ys ", "height:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailMinimumSizeheight", This.ThumbnailMinimumSize["height"])
        This.S_Gui["ThumbnailMinimumSizeheight"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Radio", "xs y+10 w37 vThumbnailSnapOn Checked" This.ThumbnailSnap, "On")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Radio", " xp+50 yp w37 vThumbnailSnapOff Checked" (This.ThumbnailSnap ? 0 : 1), "Off")
        This.S_Gui["ThumbnailSnapOn"].OnEvent("Click", (obj, *) => gSettings_EventHandler(obj))
        This.S_Gui["ThumbnailSnapOff"].OnEvent("Click", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15 ", "pixel:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailSnap_Distance", This.ThumbnailSnap_Distance)
        This.S_Gui["ThumbnailSnap_Distance"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+9 ", "Milliseconds:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "xp+80 yp-3 w40 vMinimizeclients_Delay", This.Minimizeclients_Delay)
        This.S_Gui["Minimizeclients_Delay"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        gSettings_EventHandler(obj) {
            if (obj.name = "Suspend_Hotkeys_Hotkey") {
                This.Suspend_Hotkeys_Hotkey := Trim(obj.value, "`n ")
                This.NeedRestart := 1
            }
            else if (obj.name = "Hotkey_Scoope") {
                This.Global_Hotkeys := (obj.value = 1 ? 1 : 0)
                This.NeedRestart := 1
            }
            else if (obj.name = "ThumbnailBackgroundColor") {
                This.ThumbnailBackgroundColor := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ThumbnailStartLocationx") {
                This.ThumbnailStartLocation["x"] := obj.value
            }
            else if (obj.name = "ThumbnailStartLocationy") {
                This.ThumbnailStartLocation["y"] := obj.value
            }
            else if (obj.name = "ThumbnailStartLocationwidth") {
                This.ThumbnailStartLocation["width"] := obj.value
            }
            else if (obj.name = "ThumbnailStartLocationheight") {
                This.ThumbnailStartLocation["height"] := obj.value
            }
            else if (obj.name = "ThumbnailMinimumSizewidth") {
                This.ThumbnailMinimumSize["width"] := obj.value
            }
            else if (obj.name = "ThumbnailMinimumSizeheight") {
                This.ThumbnailMinimumSize["height"] := obj.value
            }
            else if (obj.name = "ThumbnailSnapOn") {
                This.ThumbnailSnap := 1
            }
            else if (obj.name = "ThumbnailSnapOff") {
                This.ThumbnailSnap := 0
            }
            else if (obj.name = "ThumbnailSnap_Distance") {
                This.ThumbnailSnap_Distance := obj.value
            }
            else if (obj.name = "Minimizeclients_Delay") {
                This.Minimizeclients_Delay := obj.value
                This.NeedRestart := 1
            }
            SetTimer(This.Save_Settings_Delay_Timer, -200)
        }
    }

    ;This Function creates all Settings controls for the Profile Settings Button
    Profile_Settings(visible?) {
        This.S_Gui.Controls.Profile_Settings := [], This.S_Gui.Controls.Profile_Settings.PsDDL := Map()

        ;This.S_Gui.Controls.Profile_Settings.Push This.S_Gui.Add("GroupBox", "x20 y80 h200 w500 vPSGroupBox", "")
        This.S_Gui.Controls.Profile_Settings.Push This.S_Gui.Add("Text", "x58 y95", "Select Profile:")

        This.SelectProfile_DDL := This.S_Gui.Add("DDL", "w200 xp-30 yp+18 Section vSelectedProfile", This.Profiles_to_Array())
        This.S_Gui.Controls.Profile_Settings.Push This.SelectProfile_DDL
        This.SelectProfile_DDL.Choose(This.LastUsedProfile)
        This.SelectProfile_DDL.OnEvent("Change", (obj,*) => This._Button_Load(Obj))

        Button_Delete := This.S_Gui.Add("Button", "w60 xs+360 yp-2 ", "Delete")
        This.S_Gui.Controls.Profile_Settings.Push Button_Delete
        Button_Delete.OnEvent("Click", ObjBindMethod(This, "Delete_Profile"))

        Button_New := This.S_Gui.Add("Button", "wp x+5 yp ", "New")
        This.S_Gui.Controls.Profile_Settings.Push Button_New
        Button_New.OnEvent("Click", ObjBindMethod(This, "Create_Profile"))

        ;*Seperator line
        This.Seperator_text := This.S_Gui.Add("Text", "xs+15 y+5 w460 h2 +0x10")
        This.S_Gui.Controls.Profile_Settings.Push This.Seperator_text

        This.S_Gui.Controls.Profile_Settings.Push This.S_Gui.Add("Text", "xp+190 y+5", "Profile Settings:")

        This.Seetings_DDL := This.S_Gui.Add("DDL", "w180 xp-40 y+5 vSeetings_Props", This._ProfileProps)
        This.Seetings_DDL.Choose(1)
        ;This.Seetings_DDL.OnEvent("Change", ObjBindMethod(This, "ProfileSettings_DDL"))
        This.S_Gui.Controls.Profile_Settings.Push This.Seetings_DDL

        ;*Seperator line
        This.S_Gui.Controls.Profile_Settings.Push This.S_Gui.Add("Text", "x150 yp+30 w260 h2 Section +0x10")

        ;Sets all controls invisible at beginning
        for k, v in This.S_Gui.Controls.Profile_Settings
            v.Visible := 0

    }

    ClientSettings_Ctrl(visible?) {
        This.S_Gui.Controls.Profile_Settings.PsDDL["Client Settings"] := [], ClientSettings := []

        ClientSettings.Push This.S_Gui.Add("GroupBox", "x20 y80 h400 w500 Section", "")
        ClientSettings.Push This.S_Gui.Add("Text", " xp+15 yp+140 Section ", "Minimize Inactive Clients:")
        ClientSettings.Push This.S_Gui.Add("Text", "xs y+15 ", "Always Maximize Clients:")
        ClientSettings.Push This.S_Gui.Add("Text", "xs y+15 ", "Dont Minimize Clients:")

        ClientSettings.Push This.S_Gui.Add("CheckBox", "xs+230 ys Section vMinimizeInactiveClients Checked" This.MinimizeInactiveClients, "On/Off")
        This.S_Gui["MinimizeInactiveClients"].OnEvent("Click", (obj, *) => cSettings_EventHandler(obj))

        ClientSettings.Push This.S_Gui.Add("CheckBox", "xs y+15 vAlwaysMaximize Checked" This.AlwaysMaximize, "On/Off")
        This.S_Gui["AlwaysMaximize"].OnEvent("Click", (obj, *) => cSettings_EventHandler(obj))

        ClientSettings.Push This.S_Gui.Add("Edit", "xs y+15 w220 h180 vDont_Minimize_Clients -Wrap", This.Dont_Minimize_List())
        This.S_Gui["Dont_Minimize_Clients"].OnEvent("Change", (obj, *) => cSettings_EventHandler(obj))

        ;Pulls the GUI Object into the Map
        This.S_Gui.Controls.Profile_Settings.PsDDL["Client Settings"] := ClientSettings

        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Client Settings"]
            v.Visible := 0

        cSettings_EventHandler(obj) {
            if (obj.name = "MinimizeInactiveClients") {
                This.MinimizeInactiveClients := obj.value
            }
            else if (obj.name = "AlwaysMaximize") {
                This.AlwaysMaximize := obj.value
            }
            else if (obj.name = "TrackClientPossitions") {
                This.TrackClientPossitions := obj.value
            }
            else if (obj.name = "Dont_Minimize_Clients") {
                This.Dont_Minimize_Clients := obj.value
            }
            SetTimer(This.Save_Settings_Delay_Timer, -200)
        }
    }

    ;TODO Needs to be implemented - Add Propertys
    ; User defined colurs per Client
    Custom_ColorsCtrl() {
        This.S_Gui.Controls.Profile_Settings.PsDDL["Custom Colors"] := [], CustomColors := []
        CustomColors.Push This.S_Gui.Add("GroupBox", "x20 y80 h480 w500 Section", "")

        CustomColors.Push This.S_Gui.Add("Text", " xp+25 yp+140 Section ", "Custom Colors Active On/Off")
        CustomColors.Push This.S_Gui.Add("Text", " x70 yp+40  ", "Character name")
        CustomColors.Push This.S_Gui.Add("Text", " xp+150 yp ", "Border Color")
        CustomColors.Push This.S_Gui.Add("Text", " xp+130 yp ", "Text Color")

        CustomColors.Push This.S_Gui.Add("CheckBox", " xs+200 ys vCcoloractive Checked" This.CustomColorsActive, " ON / Off")
        This.S_Gui["Ccoloractive"].OnEvent("Click", (obj, *) => Cclors_Eventhandler(obj))

        CustomColors.Push This.S_Gui.Add("Edit", " x60 yp+60 w150 h250 -Wrap vCchars", This.CustomColors_AllCharNames)
        This.S_Gui["Cchars"].OnEvent("Change", (obj, *) => Cclors_Eventhandler(obj))

        CustomColors.Push This.S_Gui.Add("Edit", " x+10 yp w120 hp -Wrap vCBorderColor", This.CustomColors_AllBColors)
        This.S_Gui["CBorderColor"].OnEvent("Change", (obj, *) => Cclors_Eventhandler(obj))

        CustomColors.Push This.S_Gui.Add("Edit", " x+10 yp wp hp -Wrap vCTextColor", This.CustomColors_AllTColors)
        This.S_Gui["CTextColor"].OnEvent("Change", (obj, *) => Cclors_Eventhandler(obj))


        This.S_Gui.Controls.Profile_Settings.PsDDL["Custom Colors"] := CustomColors
        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Custom Colors"]
            v.Visible := 0

        Cclors_Eventhandler(obj) {
            if (obj.Name = "Ccoloractive") {
                This.CustomColorsActive := obj.value
            }
            else if (obj.Name = "Cchars") {
                indexOld := This.IndexcChars
                This.CustomColors_AllCharNames := obj.value
                if (indexOld < This.IndexcChars) {
                    obj.value := This.CustomColors_AllCharNames
                    ControlSend("^{End}", obj.Hwnd)
                }
                This.NeedRestart := 1
            }
            else if (obj.Name = "CBorderColor") {
                indexOld := This.IndexcBorder
                This.CustomColors_AllBColors := obj.value
                if (indexOld < This.IndexcBorder) {
                    obj.value := This.CustomColors_AllBColors
                    ControlSend("^{End}", obj.Hwnd)
                }
                This.NeedRestart := 1
            }
            else if (obj.Name = "CTextColor") {
                indexOld := This.IndexcText
                This.CustomColors_AllTColors := obj.value
                if (indexOld < This.IndexcText) {
                    obj.value := This.CustomColors_AllTColors
                    ControlSend("^{End}", obj.Hwnd)
                }
                This.NeedRestart := 1
            }            
            SetTimer(This.Save_Settings_Delay_Timer, -200)
        }
    }


    Hotkey_GroupsCtrl() {
        This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkey Groups"] := [], Hotkey_Groups := []

        Hotkey_Groups.Push This.S_Gui.Add("GroupBox", "x20 y80 h440 w500 Section", "")
        Hotkey_Groups.Push This.S_Gui.Add("Text", "x58 yp+130", "Select Group:")
        ddl := This.S_Gui.Add("DropDownList", " xp-30 yp+18 w180 vHotkeyGroupDDL", This.GetGroupList())
        Hotkey_Groups.Push ddl
        This.S_Gui["HotkeyGroupDDL"].OnEvent("Change", (*) => SetEditText(ddl, EditBox, HKForwards, HKBackwards))

        DeleteButton := This.S_Gui.Add("Button", "xs+370 yp-1 w60", "Delete")
        NewButton := This.S_Gui.Add("Button", "x+5 yp w60", "New")
        DeleteButton.OnEvent("Click", (*) => Delete_Group(ddl, HKForwards, HKBackwards, EditBox))
        NewButton.OnEvent("Click", (*) => CreateNewGroup(ddl, HKForwards, HKBackwards, EditBox))

        Hotkey_Groups.Push DeleteButton
        Hotkey_Groups.Push NewButton

        EditBox := This.S_Gui.Add("Edit", "xs+8 y275 w250 h225 -Wrap +HScroll Disabled vHKCharlist")
        Hotkey_Groups.Push EditBox
        This.S_Gui["HKCharlist"].OnEvent("Change", (obj, *) => SaveHKGroupList(obj))

        Hotkey_Groups.Push This.S_Gui.Add("Text", "xs300 yp20", "Forwards Hotkey:")
        HKForwards := This.S_Gui.Add("Edit", "xp yp+20 w150 Disabled vForwardsKey")
        Hotkey_Groups.Push HKForwards
        This.S_Gui["ForwardsKey"].OnEvent("Change", (obj, *) => SaveHKGroupList(obj))

        Hotkey_Groups.Push This.S_Gui.Add("Text", "xp yp50", "Backwards Hotkey:")
        HKBackwards := This.S_Gui.Add("Edit", "xp yp+20 w150 Disabled vBackwardsdKey")
        Hotkey_Groups.Push HKBackwards
        This.S_Gui["BackwardsdKey"].OnEvent("Change", (obj, *) => SaveHKGroupList(obj))

        This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkey Groups"] := Hotkey_Groups
        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkey Groups"]
            v.Visible := 0


        CreateNewGroup(ddlObj, ForwardHKObj, BackwardHKObj, EditObj) {
            ArrayIndex := 0
            Obj := InputBox("Enter a Groupname", "Create New Group", "w200 h90")
            if (Obj.Result != "OK")
                return
            This.Hotkey_Groups[Obj.value] := []
            ddlObj.Delete()
            ddlObj.Add(This.GetGroupList())
            for k in This.Hotkey_Groups {
                if k = Obj.value {
                    ArrayIndex := A_Index
                    break
                }
            }
            EditObj.value := "", ForwardHKObj.value := "", BackwardHKObj.value := ""
            ForwardHKObj.Enabled := 1, BackwardHKObj.Enabled := 1, EditObj.Enabled := 1
            ddlObj.Choose(ArrayIndex)
            This.NeedRestart := 1
            SetTimer(This.Save_Settings_Delay_Timer, -200)
        }

        Delete_Group(ddlObj, ForwardHKObj, BackwardHKObj, EditObj) {
            if (ddlObj.Text != "" && This.Hotkey_Groups.Has(ddlObj.Text))
                This.Hotkey_Groups.Delete(ddlObj.Text)

            ddlObj.Delete()
            ddlObj.Add(This.GetGroupList())
            ForwardHKObj.value := "", BackwardHKObj.value := "", EditObj.value := ""
            ForwardHKObj.Enabled := 0, BackwardHKObj.Enabled := 0, EditObj.Enabled := 0
            This.NeedRestart := 1

            SetTimer(This.Save_Settings_Delay_Timer, -200)
        }

        SetEditText(ddlObj, EditObj, ForwardHKObj?, BackwardHKObj?) {
            text := ""
            if (ddlObj.Text != "" && This.Hotkey_Groups.Has(ddlObj.Text)) {
                for index, Names in This.Hotkey_Groups[ddlObj.Text]["Characters"] {
                    text .= Names "`n"
                }
                EditObj.value := text, EditObj.Enabled := 1
                ForwardHKObj.value := This.Hotkey_Groups[ddlObj.Text]["ForwardsHotkey"], ForwardHKObj.Enabled := 1
                BackwardHKObj.value := This.Hotkey_Groups[ddlObj.Text]["BackwardsHotkey"], BackwardHKObj.Enabled := 1
            }


        }

        SaveHKGroupList(obj) {
            if (obj.Name = "HKCharlist" && ddl.Text != "") {
                Arr := []
                for k, v in StrSplit(obj.value, "`n") {
                    Chars := Trim(v, "`n ")
                    if (Chars = "")
                        continue
                    Arr.Push(Chars)
                }
                This.Hotkey_Groups[ddl.Text]["Characters"] := Arr
            }
            else if (obj.Name = "ForwardsKey" && ddl.Text != "") {
                This.Hotkey_Groups[ddl.Text]["ForwardsHotkey"] := Trim(obj.value, "`n ")
            }
            else if (obj.Name = "BackwardsdKey" && ddl.Text != "") {
                This.Hotkey_Groups[ddl.Text]["BackwardsHotkey"] := Trim(obj.value, "`n ")
            }
            This.NeedRestart := 1
            SetTimer(This.Save_Settings_Delay_Timer, -200)
        }
    }


    HotkeysCtrl() {

        This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkeys"] := [], Hotkeys := []
        Hotkeys.Push This.S_Gui.Add("GroupBox", "x20 y80 h530 w500 Section", "")

        Charlist := "", Hklist := ""
        for index, value in This._Hotkeys {
            for name, hotkey in value {
                Charlist .= name "`n"
                Hklist .= hotkey "`n"
            }
        }

        Hotkeys.Push This.S_Gui.Add("Text", " x115 yp+130 section", "Charactername:")
        HKCharList := This.S_Gui.Add("Edit", " xp-30 yp20 w180 h350 -Wrap vHotkeyCharList", Charlist)
        Hotkeys.Push HKCharList
        HKCharList.OnEvent("Change", (obj, *) => EventHandler(obj))

        Hotkeys.Push This.S_Gui.Add("Text", " xs+210 ys", "Hotkeys:")
        HKKeylist := This.S_Gui.Add("Edit", " xp-50 yp20 w180 h350 -Wrap vHotkeyList", Hklist)
        Hotkeys.Push HKKeylist
        HKKeylist.OnEvent("Change", (obj, *) => EventHandler(obj))

        This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkeys"] := Hotkeys
        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkeys"]
            v.Visible := 0

        ;Parse All hotkeys to a Array on value change
        EventHandler(obj) {
            tempvar := []
            ListChars := StrSplit(This.S_Gui["HotkeyCharList"].value, "`n"), ListHotkeys := StrSplit(This.S_Gui["HotkeyList"].value, "`n")
            for k, v in ListChars {
                chars := "", keys := ""
                if (A_Index <= ListChars.Length) {
                    chars := Trim(ListChars[A_Index], "`n ")
                }
                if (A_Index <= ListHotkeys.Length) {
                    keys := Trim(ListHotkeys[A_Index], "`n ")
                }
                if (A_Index > ListHotkeys.Length) {
                    keys := ""
                }
                if (chars = "")
                    continue
                tempvar.Push Map(chars, keys)
            }
            this._Hotkeys := tempvar
            This.NeedRestart := 1
            SetTimer(This.Save_Settings_Delay_Timer, -200)
        }

    }

    ThumbnailSettings_Ctrl() {
        This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Settings"] := [], ThumbnailSettings := []

        ThumbnailSettings.Push This.S_Gui.Add("GroupBox", "x20 y80 h530 w500 Section", "")

        ThumbnailSettings.Push This.S_Gui.Add("Text", "xp+15 yp+140 Section", "Show Thumbnail Text Overlay:")
        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "Thumbnail Text Color:")
        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "Thumbnail Text Size:")
        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "Thumbnail Text Font:")
        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "Thumbnail Text Margins:")
        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "Client Highligt Color:")
        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "Client Highligt Border thickness:")
        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "Show Client Highlight Border:")
        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "Hide Thumbnails On Lost Focus:")
        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "Thumbnail Opacity:")
        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "Show Thumbnails AlwaysOnTop:")

        ThumbnailSettings.Push This.S_Gui.Add("CheckBox", "xs+230 ys Section vShowThumbnailTextOverlay Checked" This.ShowThumbnailTextOverlay, "On/Off")
        This.S_Gui["ShowThumbnailTextOverlay"].OnEvent("Click", (obj, *) => ThumbnailSettings_EventHandler(obj))

        ThumbnailSettings.Push This.S_Gui.Add("Edit", "xs y+11  w120 vThumbnailTextColor -Wrap", This.ThumbnailTextColor)
        ThumbnailSettings.Push This.S_Gui.Add("Text", " x+5 yp+3 ", "Hex or RGB")
        This.S_Gui["ThumbnailTextColor"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        ThumbnailSettings.Push This.S_Gui.Add("Edit", "xs y+10 w30 vThumbnailTextSize -Wrap", This.ThumbnailTextSize)
        This.S_Gui["ThumbnailTextSize"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        ThumbnailSettings.Push This.S_Gui.Add("Edit", "xs y+8 w120 vThumbnailTextFont -Wrap", This.ThumbnailTextFont)
        This.S_Gui["ThumbnailTextFont"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+12", "width px:")
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x+5 yp-4  w40 vThumbnailTextMarginsx -Wrap", This.ThumbnailTextMargins["x"])
        This.S_Gui["ThumbnailTextMarginsx"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs+100 yp+4 ", "height px:")
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "xp+60 yp-4  w40 vThumbnailTextMarginsy -Wrap", This.ThumbnailTextMargins["y"])
        This.S_Gui["ThumbnailTextMarginsy"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        ThumbnailSettings.Push This.S_Gui.Add("Edit", "xs y+7 w120 vClientHighligtColor -Wrap", This.ClientHighligtColor)
        ThumbnailSettings.Push This.S_Gui.Add("Text", " x+5 yp+3 ", "Hex or RGB")
        This.S_Gui["ClientHighligtColor"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))


        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "px:")
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x+5 yp-3  w30 vClientHighligtBorderthickness -Wrap", This.ClientHighligtBorderthickness)
        This.S_Gui["ClientHighligtBorderthickness"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        ThumbnailSettings.Push This.S_Gui.Add("CheckBox", "xs y+10 vShowClientHighlightBorder Checked" This.ShowClientHighlightBorder, "On/Off")
        This.S_Gui["ShowClientHighlightBorder"].OnEvent("Click", (obj, *) => ThumbnailSettings_EventHandler(obj))

        ThumbnailSettings.Push This.S_Gui.Add("CheckBox", "xs y+16 vHideThumbnailsOnLostFocus Checked" This.HideThumbnailsOnLostFocus, "On/Off")
        This.S_Gui["HideThumbnailsOnLostFocus"].OnEvent("Click", (obj, *) => ThumbnailSettings_EventHandler(obj))

        ThumbnailSettings.Push This.S_Gui.Add("Text", " xs y+15 ", "%")
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x+4 yp-4  w40 vThumbnailOpacity -Wrap", IntegerToPercentage(This.ThumbnailOpacity))
        This.S_Gui["ThumbnailOpacity"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        ThumbnailSettings.Push This.S_Gui.Add("CheckBox", "xs y+12 vShowThumbnailsAlwaysOnTop Checked" This.ShowThumbnailsAlwaysOnTop, "On/Off")
        This.S_Gui["ShowThumbnailsAlwaysOnTop"].OnEvent("Click", (obj, *) => ThumbnailSettings_EventHandler(obj))


        This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Settings"] := ThumbnailSettings
        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Settings"] {
            v.Visible := 0
        }

        ;Parse All hotkeys to a Array on value change
        ThumbnailSettings_EventHandler(obj) {
            if (obj.name = "ShowThumbnailTextOverlay") {
                This.ShowThumbnailTextOverlay := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ThumbnailTextColor") {
                This.ThumbnailTextColor := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ThumbnailTextSize") {
                This.ThumbnailTextSize := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ThumbnailTextFont") {
                This.ThumbnailTextFont := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ThumbnailTextMarginsx") {
                This.ThumbnailTextMargins["x"] := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ThumbnailTextMarginsy") {
                This.ThumbnailTextMargins["y"] := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ClientHighligtColor") {
                This.ClientHighligtColor := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ClientHighligtBorderthickness") {
                This.ClientHighligtBorderthickness := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ShowClientHighlightBorder") {
                This.ShowClientHighlightBorder := obj.value
            }
            else if (obj.name = "HideThumbnailsOnLostFocus") {
                This.HideThumbnailsOnLostFocus := obj.value
            }
            else if (obj.name = "ThumbnailOpacity") {
                This.ThumbnailOpacity := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ShowThumbnailsAlwaysOnTop") {
                This.ShowThumbnailsAlwaysOnTop := obj.value
                This.NeedRestart := 1
            }

            SetTimer(This.Save_Settings_Delay_Timer, -200)
        }
    }

    Thumbnail_visibilityCtrl() {
        This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Visibility"] := [], Thumbnail_visibility := []

        Thumbnail_visibility.Push This.S_Gui.Add("GroupBox", "x20 y80 h610 w500 Section", "")
        Thumbnail_visibility.Push This.S_Gui.Add("Text", "xp+140 yp+130 w250", "Select any Client to hide the Thumbnail")
        This.Tv_LV := This.S_Gui.Add("ListView", "xp+15 yp+30 w210 Checked -LV0x10 -Multi r20 -Sort vVisibility_List", ["Client Name       "])
        Thumbnail_visibility.Push This.Tv_LV

        for k, v in This.compare_openclients_with_list() {
            if (k != "EVE" || v != "") {
                if This.Thumbnail_visibility.Has(v)
                    This.Tv_LV.Add("Check", v,)
                else
                    This.Tv_LV.Add("", v,)
            }
        }


        This.Tv_LV.ModifyCol(1, 150), This.Tv_LV.ModifyCol(2, 115)
        This.Tv_LV.OnEvent("ItemCheck", ObjBindMethod(This, "_Tv_LVSelectedRow"))

        This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Visibility"] := Thumbnail_visibility
        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Visibility"]
            v.Visible := 0


    }

    On_WM_MOUSEMOVE(wParam, lParam, msg, Hwnd) {
        static PrevHwnd := 0
        if (Hwnd != PrevHwnd) {
            Text := "", ToolTip() ; Turn off any previous tooltip.
            CurrControl := GuiCtrlFromHwnd(Hwnd)
            if CurrControl {
                if !CurrControl.HasProp("ToolTip")
                    return ; No tooltip for this control.
                Text := CurrControl.ToolTip
                SetTimer () => ToolTip(Text), -1000
                SetTimer () => ToolTip(), -4000 ; Remove the tooltip.
            }
            PrevHwnd := Hwnd
        }
    }

    Profiles_to_Array() {
        ll := []
        for k, v in This.Profiles
            ll.Push(k)
        return ll
    }

    Dont_Minimize_List() {
        list := ""
        for k in This.Dont_Minimize_Clients {
            list .= k "`n"
        }
        return list
    }

    _Button_Load(obj?,*) {
        if (IsSet(obj))
            This.NeedRestart := 1
        
        This.LastUsedProfile := This.S_Gui["SelectedProfile"].Text        
        This.Refresh_ControlValues()

        if (This.S_Gui["SelectedProfile"].Text = "Default") {
            for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL {
                for _, ob in v {
                    ob.Enabled := 0
                }
            }
        }
        SetTimer(This.Save_Settings_Delay_Timer, -200)
    }

    Refresh_ControlValues() {
        ; Global Settings
        This.S_Gui["Suspend_Hotkeys_Hotkey"].value := This.Suspend_Hotkeys_Hotkey
        This.S_Gui["Hotkey_Scoope"].value := (This.Global_Hotkeys ? 1 : 2)
        This.S_Gui["ThumbnailBackgroundColor"].value := This.ThumbnailBackgroundColor
        This.S_Gui["ThumbnailStartLocationx"].value := This.ThumbnailStartLocation["x"]
        This.S_Gui["ThumbnailStartLocationy"].value := This.ThumbnailStartLocation["y"]
        This.S_Gui["ThumbnailStartLocationwidth"].value := This.ThumbnailStartLocation["width"]
        This.S_Gui["ThumbnailStartLocationheight"].value := This.ThumbnailStartLocation["height"]
        This.S_Gui["ThumbnailMinimumSizewidth"].value := This.ThumbnailMinimumSize["width"]
        This.S_Gui["ThumbnailMinimumSizeheight"].value := This.ThumbnailMinimumSize["height"]
        This.S_Gui["ThumbnailSnapOn"].value := This.ThumbnailSnap
        This.S_Gui["ThumbnailSnapOff"].value := (This.ThumbnailSnap ? 0 : 1)
        This.S_Gui["ThumbnailSnap_Distance"].value := This.ThumbnailSnap_Distance

        ;Client Settings
        This.S_Gui["MinimizeInactiveClients"].value := This.MinimizeInactiveClients
        This.S_Gui["Minimizeclients_Delay"].value := This.Minimizeclients_Delay
        This.S_Gui["AlwaysMaximize"].value := This.AlwaysMaximize
        This.S_Gui["Dont_Minimize_Clients"].value := This.Dont_Minimize_List()

        ;Custom Colors
        This.S_Gui["Ccoloractive"].value := This.CustomColorsActive
        This.S_Gui["Cchars"].value := This.CustomColors_AllCharNames
        This.S_Gui["CBorderColor"].value := This.CustomColors_AllBColors
        This.S_Gui["CTextColor"].value := This.CustomColors_AllTColors


        ;Hotkey Groups
        This.S_Gui["HotkeyGroupDDL"].Delete()
        This.S_Gui["HotkeyGroupDDL"].Add(This.GetGroupList())
        This.S_Gui["ForwardsKey"].value := "", This.S_Gui["ForwardsKey"].Enabled := 0
        This.S_Gui["BackwardsdKey"].value := "", This.S_Gui["BackwardsdKey"].Enabled := 0
        This.S_Gui["HKCharlist"].value := "", This.S_Gui["HKCharlist"].Enabled := 0

        ;Hotkeys
        Charlist := "", Hklist := ""
        for index, value in This._Hotkeys {
            for name, hotkey in value {
                Charlist .= name "`n"
                Hklist .= hotkey "`n"
            }
        }
        This.S_Gui["HotkeyCharList"].value := Charlist
        This.S_Gui["HotkeyList"].value := Hklist

        ;Thumbnail Settings
        This.S_Gui["ShowThumbnailTextOverlay"].value := This.ShowThumbnailTextOverlay
        This.S_Gui["ThumbnailTextColor"].value := This.ThumbnailTextColor
        This.S_Gui["ThumbnailTextSize"].value := This.ThumbnailTextSize
        This.S_Gui["ThumbnailTextFont"].value := This.ThumbnailTextFont
        This.S_Gui["ThumbnailTextMarginsx"].value := This.ThumbnailTextMargins["x"]
        This.S_Gui["ThumbnailTextMarginsy"].value := This.ThumbnailTextMargins["y"]
        This.S_Gui["ClientHighligtColor"].value := This.ClientHighligtColor
        This.S_Gui["ClientHighligtBorderthickness"].value := This.ClientHighligtBorderthickness
        This.S_Gui["ShowClientHighlightBorder"].value := This.ShowClientHighlightBorder
        This.S_Gui["HideThumbnailsOnLostFocus"].value := This.HideThumbnailsOnLostFocus
        This.S_Gui["ThumbnailOpacity"].value := IntegerToPercentage(This.ThumbnailOpacity)
        This.S_Gui["ShowThumbnailsAlwaysOnTop"].value := This.ShowThumbnailsAlwaysOnTop

        ;Thumbnail Visibility
        This.S_Gui["Visibility_List"].Delete()
        for k, v in This.compare_openclients_with_list() {
            if (k != "EVE" || v != "") {
                if This.Thumbnail_visibility.Has(v)
                    This.Tv_LV.Add("Check", v,)
                else
                    This.Tv_LV.Add("", v,)
            }
        }

        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL {
            for _, ob in v {
                ob.Enabled := 1
            }
            This.S_Gui["HKCharlist"].Enabled := 0
            This.S_Gui["ForwardsKey"].Enabled := 0
            This.S_Gui["BackwardsdKey"].Enabled := 0
        }
    }


    compare_openclients_with_list() {
        EvENameList := []
        for EveHwnd in This.ThumbWindows.OwnProps() {
            try {
                if title := This.CleanTitle(WinGetTitle("Ahk_Id " EveHwnd) = "") {
                    continue
                }
                EvENameList.Push This.CleanTitle(WinGetTitle("Ahk_Id " EveHwnd))
            }
        }
        return EvENameList
    }


    GetGroupList() {
        List := []
        if (IsObject(This.Hotkey_Groups)) {
            for k in This.Hotkey_Groups {
                List.Push(k)
            }
            return List
        }
        else
            return []
    }


}
;Class End


IntegerToPercentage(integerValue) {
    percentage := (integerValue < 0 ? 0 : integerValue > 255 ? 100 : Round(integerValue * 100 / 255))
    return percentage
}


CompareArrays(arr1, arr2) {
    commonValues := {}

    for _, value in arr1 {
        if (IsInArray(value, arr2))
            commonValues.%value% := 1
        else
            commonValues.%value% := 0
    }

    for _, value in arr2 {
        if (!IsInArray(value, arr1))
            commonValues.%value% := 0
    }

    return commonValues
}

IsInArray(value, arr) {
    for _, item in arr {
        if (item = value)
            return true
    }
    return false
}
