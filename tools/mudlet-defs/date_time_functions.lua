---  Parses the specified source string, according to the format if given, to return a representation of the date/time. If as_epoch is provided and true, the return value will be a Unix epoch — the number of seconds since 1970. This is a useful format for exchanging date/times with other systems. If as_epoch is false, then a Lua time table will be returned. Details of the time tables are provided in the [http://www.lua.org/pil/22.1.html Lua Manual].
--- 
--- ##  Supported Format Codes
--- ```lua
--- %b = Abbreviated Month Name
--- %B = Full Month Name
--- %d = Day of Month
--- %H = Hour (24-hour format)
--- %I = Hour (12-hour format, requires %p as well)
--- %p = AM or PM
--- %m = 2-digit month (01-12)
--- %M = 2-digit minutes (00-59)
--- %S = 2-digit seconds (00-59)
--- %y = 2-digit year (00-99), will automatically prepend 20 so 10 becomes 2010 and not 1910.
--- %Y = 4-digit year.
--- ```
function datetime:parse(source, format, as_epoch)
end

--- This function returns the seconds since [https://en.wikipedia.org/wiki/Unix_time Unix epoch] with milliseconds.
--- 
--- ## Example
--- ```lua
--- getEpoch() -- will show e.g. 1523555867.191
--- ```
function getEpoch()
end

--- returntype takes a boolean value (in Lua anything but false or nil will translate to true). If false, the function will return a table in the following format:
--- 
--- ```{ 'min': #, 'year': #, 'month': #, 'day': #, 'sec': #, 'hour': #, 'msec': # }```
--- 
--- If true, it will return the date and time as a string using a format passed to the format arg or the default of "yyyy.MM.dd hh:mm:ss.zzz" if none is supplied:
--- 
--- ```2012.02.18 00:52:52.489```
--- 
--- Format expressions:
--- 
--- ```
--- h               the hour without a leading zero (0 to 23 or 1 to 12 if AM/PM display)
--- hh              the hour with a leading zero (00 to 23 or 01 to 12 if AM/PM display)
--- H               the hour without a leading zero (0 to 23, even with AM/PM display)
--- HH              the hour with a leading zero (00 to 23, even with AM/PM display)
--- m               the minute without a leading zero (0 to 59)
--- mm              the minute with a leading zero (00 to 59)
--- s               the second without a leading zero (0 to 59)
--- ss              the second with a leading zero (00 to 59)
--- z               the milliseconds without leading zeroes (0 to 999)
--- zzz             the milliseconds with leading zeroes (000 to 999)
--- AP or A         use AM/PM display. AP will be replaced by either "AM" or "PM".
--- ap or a         use am/pm display. ap will be replaced by either "am" or "pm".
--- 
--- d               the day as number without a leading zero (1 to 31)
--- dd              the day as number with a leading zero (01 to 31)
--- ddd             the abbreviated localized day name (e.g. 'Mon' to 'Sun'). Uses QDate::shortDayName().
--- dddd            the long localized day name (e.g. 'Monday' to 'Qt::Sunday'). Uses QDate::longDayName().
--- M               the month as number without a leading zero (1-12)
--- MM              the month as number with a leading zero (01-12)
--- MMM             the abbreviated localized month name (e.g. 'Jan' to 'Dec'). Uses QDate::shortMonthName().
--- MMMM            the long localized month name (e.g. 'January' to 'December'). Uses QDate::longMonthName().
--- yy              the year as two digit number (00-99)
--- yyyy            the year as four digit number
--- ```
--- All other input characters will be ignored. Any sequence of characters that are enclosed in single quotes will be treated as text and not be used as an expression. Two consecutive single quotes (<nowiki>`</nowiki>) are replaced by a single single quote in the output.
--- 
--- ## Example
--- ```lua
--- -- Get time as a table
--- getTime()
--- 
--- -- Get time with default string
--- getTime(true)
--- 
--- -- Get time without date and milliseconds
--- getTime(true, "hh:mm:ss")
--- ```
function getTime(returntype, format)
end

---  Returns the timestamp string as it’s seen when you enable the timestamps view (blue i button bottom right).
--- 
--- Note:  
--- Available since Mudlet 1.1.0-pre1.
--- 
--- ## Example:
--- ```lua
--- -- echo the timestamp of the current line in a trigger:
--- echo(getTimestamp(getLineCount()))
--- 
--- -- insert the timestamp into a "chat" miniconsole
--- cecho("chat", "<red>"..getTimestamp(getLineCount()))
--- ```
function getTimestamp(console_name, lineNumber)
end

---  Converts seconds into hours, minutes and seconds, displaying the result as a table. An optional second argument can be passed to return the result as an echo.
--- 
--- Note:  Available in Mudlet 3.0.
--- 
--- ## Example:
--- ```lua
--- --Determine the total number of seconds and display:
--- shms(65535, true)
--- ```
function shms(seconds, bool)
end

