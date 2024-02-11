##  EVE-X-Preview

EVE-X-Preview is a tool for Windows that makes it easy to manage and use multiple EVE clients. 
It allows displaying thumbnails of the running EVE clients and bringing EVE clients to the foreground with a click on the thumbnail or with a set hotkey. Mouse and keyboard buttons are supported.

It is possible to create multiple profiles to quickly change the hotkey assignments, thumbnail position, and color adjustments


**In summary, this tool offers the following features:**

* Display thumbnails of active EVE clients.
* Bring an EVE client to the foreground with a hotkey, including full keyboard and mouse support.
* Create multiple profiles.
* Customize text color, size, borders, font, and position.
* Display thumbnails of varying sizes.
* Create hotkey groups.
* Save EVE client positions and restore them.
* Graphical user interface to configure all settings


**The following is not supported**
* The simultaneous sending of keyboard or mouse inputs to multiple EVE clients, also known as input broadcasting.
* Sending individual keyboard or mouse inputs.
* Displaying excerpts from the client as thumbnails.
* Manipulating EVE clients. 

#### EVE-X-Preview does not interact directly with the game clients in any way. It only allows changing the foreground window with the help of hotkeys and thumbnails. <br> No features will be added now or in the future that violate the EULA and Terms of Service of EVE Online. 



## How To Use

1. Download the EXE file from here https://github.com/g0nzo83/EVE-X-Preview/releases
2. Create a new Folder on Dektop or in Documents or where you like with the exception of the Programs folders. And move EVE-X-Preview.exe to the created folder.
3. Start EVE-X-Preview.exe. It should create a json file. This file must always be in the same folder as EVE-X-Preview.exe. It contains all your settings 
4. A tray icon should then appear at the bottom right of the taskbar. Right-click on it to access the settings. 
5. Right Click on the Tryicon and klick "Open" or double klick it and klick on "Profile Settings" create a new Profile.
6. From here on you can adjust as you like

`Important Note:`  <br> `some settings require a restart of the tool. The settings window must be closed so that the settings made there are applied`

## Run from Source

1. Download and install [Autohotkey v2](https://www.autohotkey.com/)
2. Download the Zip file from https://github.com/g0nzo83/EVE-X-Preview/releases
3. Unpack the Zip file and Run the file `Main.ahk`

## Will I get banned if I use it?
As I understand the EVE Online EULA and Terms of Service, this tool does not break any rules. <br>
Since EVE-X-Preview uses the same methods as [EVE-O Preview](https://github.com/EveOPlus/eve-o-preview), another tool which offers similar functions and is permitted, I assume that this also applies to EVE-X-Preview. <br>
Nevertheless I want to point out that the use of EVE-X-Preview or any other Thrid-Party tool is at your own risk. <br>
**I assume no liability whatsoever**

## Application Options

### **Tray Menu - Settings**

| Option | Description | 
| --- | --- |
| Open | Opens the settings window  |
| Suspend Hotkeys | Deactivates the hotkeys |
| Close all EVE clients | Closes all open EVE windows | 
| Restore Client Positions | Toggles On/ Off <br> Restores the previously saved client positions automatically if activated  |
| Save Client Positions | Saves the current position of all EVE clients so that they can be restored with Restore Client Positions <br> Positions are not saved automatically. If the position has been changed, it must be saved again |
| Save Thumbnail Positions | Saves the current position of the thumbnails. Thumbnail positions are not saved automatically. If the position has been changed, it must be saved again |
| Reload | If problems occur with the tool, it can simply be restarted with this option |
| Exit | Exits the program |





### **Global Settings**
| Option | Description | 
| --- | --- |
| Suspend Hotkeys - Hotkey |Allows you to set a hotkey to su all active hotkeys. The tray icon changes when the pause is activated and a short message is displayed next to the cursor  |
| Hotkey activation Scope | **Global: ->** Allows you to activate an EVE client with a hotkey regardless of which window you are in. <br><br> **If an EVE window is Active: ->** Activates the hotkeys only when any EVE Window is in the foreground|
| Thumbnail Background Color | Setting the background color of the thumbnail. This is only visible if the content of the thumbnail is not visible, such as when the EVE window is minimized and the thumbnail was created afterwards <br> **HEX: ->** 0xFFFFFF or #FFFFFF or FFFFFF <br> **RGB: ->** 	RGB(225,255,255) or (225,255,255) or 225,255,255|
| Thumbnail Default Location | Setting the dafault thumbnail position such as the thumbnail of the character selection screen |
| Thumbnail Minimum Size | Allows you to set a minimum size of the thumbnail to prevent it from becoming too small to edit |
| Thumbnail Snap | Allows you to switch the automatic alignment of the thumbnails to each other to On or Off |
| Thumbnail Snap Distance | Defines the range up to which the thumbnails automatically align with each other. <br> This only has an effect when Thumbnail Snap is activated |
| Minimize EVE Window Delay | Sets the delay before an inactive client is minimized after another one has been activated. This option is only used if "Minimize Inactive Client" has been activated |

### **Profile Settings - Client Settings**
| Option | Description |
| --- | --- |
| Minimize Inactive Clients | If this option is activated, all inactive clients are minimized if they are not entered in the "Dont Minimize Clients" list  |
| Always Maximize Clients | Thumbnails width. Can be set to any value from **100** to **640** points |
| Thumbnail Height | This is an important option. This means that the client is always maximized. This largely prevents the overview of the EVE client from shifting when the PC is on heavily load |
| Dont Minimize CLients| All EVE character names entered here are exempt from minimization. This is useful if you always need a current preview image of the client. Since a preview image of a minimized client can only be shown frozen  |

### **Profile Settings - Custom Colors**
| Allows you to set custom colors for the font and borders|
| --- |
| The supported syntax is: <br>HEX: -> 0xFFFFFF or #FFFFFF or FFFFFF <br> RGB: -> RGB(225,255,255) or (225,255,255) or 225,255,255|



### **Profile Settings - Hotkey Groups**
| Option | Description |
| --- | --- |
| Select Group | Enables the creation and deletion of hotkey groups. Each group must have a unique name  |
| Hotkey Groups Text field| The character names that belong to the group are entered here. The names must be entered one below the other. The activation sequence is from top to bottom |
| Forwards Hotkey <br> Backwards Hotkey | *Explanation of the hotkeys, see below* |

### **Profile Settings - Hotkeys**
|**The character names must be entered one below the other and the corresponding hotkey on the opposite side <br> The same hotkey may only be assigned to one character!** <br> *Explanation of the hotkeys, see below*|
|---|

### **Hotkeys - Explanation**
There are several ways to specify hotkeys <br> For a detailed description you can have a look at the following pages <br> [Hotkey Modifier Symbols](https://www.autohotkey.com/docs/v2/Hotkeys.htm#Symbols) and [List Of Keys](https://www.autohotkey.com/docs/v2/KeyList.htm)

| Hotkey | Description |
| ---| --- |
| 1 <br> 2 <br> Tab <br> ~ <br> Lbutton <br> Rbutton <br> Xbutton1 <br> Xbutton2 <br>Ctrl <br> Shift | These are simple hotkeys. They are defined by the letter itself or the name of the key. virtual key codes are also supported <br><br> It is not recommended to use the left or right mouse button as a simple hotkey. This would prevent you from being able to use the buttons. <br> These hotkeys can only be triggered when they are pressed alone. If another button is pressed that is not part of the hotkey, the hotkey is not triggered  |
| ........Modifierkeys:.......... <br> ^1 = Ctrl & 1 <br> +1 = Shift & 1 <br> #1 = Win & 1<br> !1 = Alt & 1 | Both Hotkey combos are valid here. <br> the difference is that a hotkey defined with a prefix allows any number of prefixes, for example: <br>  `+^1` means Shift+Control+1 <br> while the assignment of 2 buttons as a hotkey is limited to 2  for example: <br> `Shift & Ctrl & 1` is not permitted <br> while these symbols are translated into Modifierkeys like `Ctrl`and `Shift` if used as a prefix but they do not mean it if they stand alone like: `+` alone means means the actual plus key   |
| Special Prefix: <br> *1 | The `*` prefix allows the hotkey to be triggered even if it is pressed together with another button <br> This is a very useful prefix as you are not forced to press the additional key again like: <br> `*1`

### **Profile Settings - Thumbnail Settings**
| Option | Description |
| --- | --- |
| Show Thumbnail Text Overlay | Shows or removes the character name on the thumbnail |
| Thumbnail Text Colour | Sets the color of the text of the character name on the thumbnail <br> The supported syntax is: <br> HEX: -> 0xFFFFFF or #FFFFFF or FFFFFF <br> RGB: -> RGB(225,255,255) or (225,255,255) or 225,255,255 |
|Thumbnail Text Size | Changes the size of the text of the character name. |
| Thumbnail Text Font | Changes the font of the text on the Thubnail. The font must be available in the Windows system. |
| Thumbnail Text Margins | Changes the distance of the thumbnail text to the edges of the thumbnail |
| Client Highlight Color | Changes the color of the color frame displayed on the thumbnail of the active client. <br> The supported syntax is: <br> HEX: -> 0xFFFFFF or #FFFFFF or FFFFFF <br> RGB: -> RGB(225,255,255) or (225,255,255) or 225,255,255|
|Client Highlight Border thickness | Changes the thickness of color frame displayed on the thumbnail of the active client |
| Show Client Highlight Border | Activates or deactivates the display of the color frame displayed on the thumbnail of the active client |
| Hide Thumbnails on Lost Focus | If activated, the thumbnails are not displayed if no EVE client is in the foreground and active. |
| Thumbnail Opacity | Sets the transparency of the thumbnail. The values are in percent from 0-100 |
| Show Thumbnails AlwaysOnTop | If activated, the thumbnails are always displayed above all windows. |

### **Profile Settings - Thumbnail Visibility**
|The thumbnails of the selected characters are not displayed |
|---|

### Mouse Gestures and Actions

Mouse gestures are applied to the thumbnail window currently being hovered over.

| Action | Gesture |
| --- | --- |
| Activate the EVE Online client and bring it to front  | Left click the thumbnail |
| Minimize the EVE Online client | Hold Control key and click the thumbnail |
| Move thumbnail to a new position | Press right mouse button and move the mouse |
| Move all thumbnails | Hold Control and right Mousebutton and move the mouse |
| Adjust all thumbnails height and width | Press both left and right mouse buttons and move the mouse up or down |
|Adjust a single thumbnails height and width | Hold Control and the right+left mouse button and move the mouse|


## About
EVE-X-Preview is Created and Maintained by [g0nzo83](https://github.com/g0nzo83) also known as "*John Xer*" in EVE Online 
