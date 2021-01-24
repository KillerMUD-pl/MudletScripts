---  Checks to see if a given file or folder exists.
---  If it exists, it’ll return the Lua true boolean value, otherwise false.
---  See [[Manual:Miscellaneous_Functions#lfs.attributes|lfs.attributes()]] for a cross-platform solution.
--- 
--- ## Example
--- ```lua
--- -- This example works on Linux only
--- if io.exists("/home/vadi/Desktop") then
---   echo("This folder exists!")
--- else
---   echo("This folder doesn't exist.")
--- end
--- 
--- -- This example will work on both Windows and Linux.
--- if io.exists("/home/vadi/Desktop/file.tx") then
---   echo("This file exists!")
--- else
---   echo("This file doesn't exist.")
--- end
--- ```
function io.exists(path)
end

---  Returns a table with detailed information regarding a file or directory, or nil if path is invalid / file or folder does not exist.
--- 
--- ## Example
--- ```lua
--- fileInfo = lfs.attributes("/path/to/file_or_directory")
--- if fileInfo then
---     if fileInfo.mode == "directory" then
---         echo("Path points to a directory.")
---     elseif fileInfo.mode == "file" then
---         echo("Path points to a file.")
---     else
---         echo("Path points to: "..fileInfo.mode)
---     end
---     display(fileInfo) -- to see the detailed information
--- else
---     echo("The path is invalid (file/directory doesn't exist)")
--- end
--- ```
function lfs.attributes(path)
end

