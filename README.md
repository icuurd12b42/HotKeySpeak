# HotKeySpeak
Hot Key Speak is a AutoHotKey based system that allows defining JavaScript Command/Macros for Hot Keys and Voice Recognition. Macros are contextual to the active application.

##Features
1. Folder like Tree Context Nodes and Groups allows defining contextual commands.
2. Multiple Words or Sentences can run the same Command or activate a Context Node.
3. Application Context Nodes. The macros are not global, they are associated with the active application.
4. Window Context Nodes, Context Node and Groups allows to structure a context tree for the macros.
5. Written in AHK though the scripting language used for programming actions is JavaScript (ECMA3!! BE MINDFUL)
6. Has a home brew code box for editing code*
7. The edit with external code editor option makes editing with MS Code a breeze, especially with autosave enabled.
8. You can export and import parts of the command tree. !Make sure you trust the code the person shares with you!

[Sneak Peak](https://icuurd12b42.github.io/HKSHelp/default.html?topic=MainUI)





## Installation

Install require components
1. Copy the files and folder structure on your PC
2. Install AutoHotKey to run HotKeySpeak.ahk
3. Right click Edit the HotKeySpeak.bat batch file
4. Make sure the paths specified by the variables match your system for the AHK location and the project location
5. Run the batch file.

The batch file is there to make sure the program is run with the ansi-32 runner.
It is best to make a exe so that the program can be pinned and have shortcuts...

### To make an exe
The GitHub project now includes the ansi-32 compiled version as HotKeySpead.exe, you can compile it yourself.

#### With the Batch File
1) Right click Edit the full_compile.bat batch file
2) Make sure the paths specified by the variables match your system for the AHK location and the project location
3) Run the batch file.
4) HotKeySpeak.exe will be created in the project folder

#### Manual Steps
1. Run AutoHotKey's "Convert .ahk to .exe"
4. Select <install_folder>\HotKeySpeak.ahk as source
5. Select <install_folder>\HotKeySpeak.exe as destination
6. Select <install_folder>\Graphics\Icons\HotKeySpeak.ico as icon
7. Select ANSI 32Bit as Base File (bin)
8. Hit Convert

The exe can be run from any location, including a desktop or a pinned task bar shortcut

First run may show the console with every tracing message in the app making it slow to boot. Go in the options to set the console reporting to "Coder Information"



## *Code Box Issues

The Code Box is broken and does not render the text fully, giving the impression you lost code. Selecting the text will redraw the code properly. 

Also the caret is not moving right, causing confusion when typing text. 

Added a Enable Syntax Highlighting under the code boxes to enable/disable it

The Code box no longer does context sensitive help on highlighted keywords.

I strongly recommend installing MS Visual Studio Code or similar with an autosave feature to use as an external editor as the fix is slow to come for this. 




## Other Issues

If you navigate directly to the HotKeySpeak interface from an application that is monitored by the program, the program will still think it's in the program and will send command to itself

It very old JavaScript engine, not all features are present. 

Requires running with AHK ANSI-32bit runner.

Sometime the program quits, possibly a internal error

It's possible the program can crash the monitored application, use at own risk.

The Context Help for selected text does not work sometimes. you have to click the Keyword in the treeview, then scroll up to the branch node and click it to load the right panel, then go back and click the treeview item you wanted help about.

