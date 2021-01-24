--- This sends "command" directly to the network layer, skipping the alias matching. The optional second argument of type boolean (print) determines if the outgoing command is to be echoed on the screen.
--- 
--- See also:
--- see: sendAll()
--- see: speedwalk()
--- Note:  If you want your command to be checked as if it's an alias, use [[Manual:Miscellaneous Functions#expandAlias|expandAlias()]] instead - send() will ignore them.
--- 
--- ```lua
--- send("Hello Jane") --echos the command on the screen
--- send("Hello Jane", true) --echos the command on the screen
--- send("Hello Jane", false) --does not echo the command on the screen
--- 
--- -- use a variable in the send:
--- send("kick "..target)
--- 
--- -- to send directions:
--- speedwalk("s;s;w;w;w;w;w;w;w;")
--- 
--- -- to send many things:
--- sendAll("hi", "open door e", "e", "get item", "sit")
--- ```
--- 
--- Note:  Since **Mudlet 3.17.1** the optional second argument to echo the command on screen will be ineffective whilst the game server has negotiated the telnet ECHO option to provide the echoing of text we `send` to it.
function send(command, showOnScreen)
end

--- This function appends text at the end of the current line.
--- 
--- ## Parameters 
--- * `miniconsoleName:` (optional) the miniconsole to echo to, or:
--- * `labelName:` (optional) the label to echo to.
--- * `text:` text you'd like to see printed. You can use \n in an echo to insert a new line. If you're echoing this to a label, you can also use styling to colour, center, increase/decrease size of text and various other formatting options [http://doc.qt.io/qt-5/richtext-html-subset.html as listed here].
--- 
--- See also:
--- see: moveCursor()
--- see: insertText()
--- see: cecho()
--- see: decho()
--- see: hecho()
--- As of Mudlet 4.8+, a single line is capped to 10,000 characters (this is when ~200 at most will fit on one line on your screen).
--- 
--- ## Example
--- ```lua
--- -- a miniconsole example
--- 
--- -- first, determine the size of your screen
--- local windowWidth, windowHeight = getMainWindowSize()
--- 
--- -- create the miniconsole
--- createMiniConsole("sys", windowWidth-650,0,650,300)
--- setBackgroundColor("sys",255,69,0,255)
--- setMiniConsoleFontSize("sys", 8)
--- -- wrap lines in window "sys" at 40 characters per line - somewhere halfway, as an example
--- setWindowWrap("sys", 40)
--- 
--- echo("sys","Hello world!\n")
--- cecho("sys", "<:OrangeRed>This is random spam with the same background\n")
--- cecho("sys", "<blue:OrangeRed>and this is with a blue foreground. ")
--- cecho("sys", "<bisque:BlueViolet>Lastly, this is with both a foreground and a background.\n")
--- ```
--- 
--- ```lua
--- -- a label example
--- 
--- -- This example creates a transparent overlay message box to show a big warning message "You are under attack!" in the middle 
--- -- of the screen. Because the background color has a transparency level of 150 (0-255, with 0 being completely transparent 
--- -- and 255 opaque) the background text can still be read through.
--- local width, height = getMainWindowSize()
--- createLabel("messageBox",(width/2)-300,(height/2)-100,250,150,1)
--- resizeWindow("messageBox",500,70)
--- moveWindow("messageBox", (width/2)-300,(height/2)-100 )
--- setBackgroundColor("messageBox", 255, 204, 0, 200)
--- echo("messageBox", [[<p style="font-size:35px"><b><center><font color="red">You are under attack!</font></center></b></p>]])
--- ```
function echo(miniconsoleName_or_labelName, text)
end

--- This is much like echo, in that is will show text at your screen, not send anything to anywhere. However, it also works with other objects than just text, like a number, table, function, or even many arguments at once. This function is useful to easily take a look at the values of a lua table, for example. If a value is a string, it'll be in quotes, and if it's a number, it won't be quoted.
--- 
--- Note:  Do not use this to display information to end-users. It may be hard to read. It is mainly useful for developing/debugging.
--- 
--- ```lua
--- myTable = {} -- create an empty lua table
--- myTable.foo = "Hello there" -- add a text
--- myTable.bar = 23 -- add a number
--- myTable.ubar = function () echo("OK") end -- add more stuff
--- display( myTable ) -- take a look inside the table
--- ```
function display(content)
end

--- Again this will not send anything to anywhere. It will however print not to the main window, but only to the errors view. You need to open that window to see the message.
--- 
--- See also:
--- see: Errors View()
--- Note:  Do not use this to display information to end-users. It will be hard to find. It is mainly useful for developing/debugging.
--- 
--- ```lua
--- debugc(" Trigger successful!")
--- -- Text will be shown in errors view, not to main window.
--- ```
function debugc(content)
end

