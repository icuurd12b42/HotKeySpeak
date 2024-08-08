# HotKeySpeak
Hot Key Speak, a AutoHotKey based system allowing voice commands and categorizing hot key actions by application, by window or by context.



[Sneak Peak](https://icuurd12b42.github.io/HKSHelp/default.html?topic=MainUI)


You can setup what application voice commands and hot keys belong to

You can setup what active window voice commands and hot keys belong to

You can setup what context voice commands and hot keys belong to, like and "edit" context where the only subsequent actions will be "cut, "copy" and "paste"

Written in AHK though the scripting language used for programming actions is JavaScript (ECMA3!! BE MINDFUL)

Has a home brew code box for editing code

Has a "Edit With MS Code" integration


## Installation

Install require components
1. Copy the files and folder structure on your PC
2. Install AutohotKey to run HotKeySpeak.ahk
You must run (double click on) HotKeySpeak.ahk from the install folder to make AutoHotKey run the script with the install folder as working folder. It is best to make a exe out of the project. 


To make an exe
1. Run AutohotKey's "Convert .ahk to .exe"
4. Select <install_folder>\HotKeySpeak.ahk as source
5. Select <install_folder>\HotKeySpeak.exe as destination
6. Select <install_folder>\Graphics\Icons\HotKeySpeak.ico as icon
7. Select ANSI 32Bit as Base File (bin)
8. Hit Convert
The exe can be run from any location, including a desktop or a pinned task bar shortcut


## Code Box Issues

The Code Box is broken and does not render the text fully, giving the impression you lost code. Selecting the tex will redraw the code properly. 

Also the caret is not moving right, causing confusion when typing text. 

The Code box not longer does context sensitive help on highlighted keywords.

Disabling the Code Box will fix these issues. You can Disable Code Box by renaming tmcsyntaxEB.dll to tmcsyntaxEB.dll.old, or deleting the file or remove the reference from the code. You will not noger have highlighting but the F1 context help will work.

I recomend you use the External Code Editor method available bottom right buttons below the native code box.



## Other Issues

If you navigate directly to the HotKeySpeak inteface from an application that is monitored by the program, the program will still think it's in the program and will send command to itself

It very old Javascipt engine, not all features are present. 

Requires running with ahk 32bit.

Full Compile Bat file was never completed.

First run will show console with every tracing message. Got in the options to set the console reporting to "Coder Information"
