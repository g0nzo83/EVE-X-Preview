#Requires AutoHotkey v2.0

#Include <DefaultJSON> ; The Default Settings Values
#Include <JSON>
#Include <LiveThumb>
#Include <../src/Main_Class>
#Include <../src/ThumbWindow>
#Include <../src/TrayMenu>
#Include <../src/Propertys>
#Include <../src/Settings_Gui>

#SingleInstance Force
Persistent
ListLines False
KeyHistory 0

CoordMode "Mouse", "Screen" ; to track Window Mouse possition while DragMoving the thumbnails
SetWinDelay -1
FileEncoding("UTF-8") ; Encoding for JSSON file

SetTitleMatchMode 3

A_MaxHotKeysPerInterval := 10000 

/*
TODO #########################
*/

;@Ahk2Exe-Let U_version = 1.0.5.
;@Ahk2Exe-SetVersion %U_version%
;@Ahk2Exe-SetFileVersion %U_version%
;@Ahk2Exe-SetCopyright gonzo83
;@Ahk2Exe-SetDescription EVE-X-Preview
;@Ahk2Exe-SetProductName EVE-X-Preview
;@Ahk2Exe-ExeName EVE-X-Preview

;@Ahk2Exe-AddResource icon.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource icon-suspend.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource icon.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource icon-suspend.ico, 208  ; Replaces 'S on red'

;@Ahk2Exe-SetMainIcon icon.ico

if !(A_IsCompiled)
    TraySetIcon("icon.ico",,true)

; Catch all unhandled Errors to prevent the Script from stopping 

;OnError(Error_Handler)

Call := Main_Class()

Load_JSON() {
    DJSON := JSON.Load(default_JSON)
    if !(FileExist("EVE-X-Preview.json")) {
        FileAppend(JSON.Dump(DJSON,,"    " ), "EVE-X-Preview.json")
        _JSON :=  JSON.Load(FileRead("EVE-X-Preview.json"))
        return _JSON
    }
    else {
        Try {
            _JSON := JsonMergeNoOverwrite(
                                            DJSON,
                                            JSON.Load(FileRead("EVE-X-Preview.json"))
                                        )
            FileDelete("EVE-X-Preview.json")   
            FileAppend(JSON.Dump(_JSON,,"    " ), "EVE-X-Preview.json")
        }
        catch as e  {
            value := MsgBox("The settings file is corrupted. Do you want to create a new one?",,"OKCancel")
            if (value = "Cancel") 
                ExitApp()

            FileDelete("EVE-X-Preview.json")
            FileAppend(JSON.Dump(DJSON,, "    "), "EVE-X-Preview.json")
            _JSON :=  JSON.Load(FileRead("EVE-X-Preview.json"))
        }
    }
    return _JSON
}

;Compare the User json wit the default Json to check if any key changed for possible future updates.
JsonMergeNoOverwrite(obj1, obj2) {
    for key, value in obj1 {
        if (obj2.Has(key)) {
            if (IsObject(value) && IsObject(obj2[key]))
                obj2[key] := JsonMergeNoOverwrite(value, obj2[key])
        } else {
            obj2[key] := value
        }
    }
    return obj2
}

; Hanles unmanaged Errors
Error_Handler(Thrown, Mode) {
    return -1
}