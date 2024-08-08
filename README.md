# HotKeySpeak
Hot Key Speak, a AutoHotKey based system allowing voice commands and categorizing hot key actions by application, by window or by context.



[Sneak Peak](https://icuurd12b42.github.io/HKSHelp/default.html?topic=MainUI)


You can setup what application voice commands and hot keys belong to

You can setup what active window voice commands and hot keys belong to

You can setup what context voice commands and hot keys belong to, like and "edit" context where the only subsequent actions will be "cut, "copy" and "paste"

Written in AHK though the scripting language used for programming actions is JavaScript (ECMA3!! BE MINDFUL)

Has a home brew code box for editing code

Has a "Edit With MS Code" integration


## Code Box Issues

The Code Box is broken and does not render the text fully, giving the impression you lost code and that caret is not moving right. selecting the tex will redraw the code properly.

The Code box not longer does context sensitive help on highlighted keywords to the help file in github.

Disabling the Code Box will fix these 2 issues. You can Disable Code Box by renaming tmcsyntaxEB.dll to tmcsyntaxEB.dll.old, or deleting the file or remove the reference from the code. You will not noger have highliting but the F1 context help will work.

I recomend you use the External Code Editor method available bottom right buttons below the native code box



## Other Issues

If you navigate directly to the HotKeySpeak inteface from an application that is monitored by the program, the program will still think it's in the program and will send command to itself

It very old Javascipt engine, not all features are present. 

Requires running with ahk 32bit.

Full Compile Bat file was never completed.

First run will show console with every tracing message. Got in the options to set the console reporting to "Coder Information"
