--- Adds the given word to the custom profile or shared dictionary (whichever is selected in preferences).
--- 
---  Returns true on success (the word was actually `added` to the dictionary by this call) and nil+msg on error - including if the word was already there - this is so that if you have other scripts that you wish to run when a word was added you can make their execution conditional on success here.
--- 
--- See also:
--- see: removeWordFromDictionary()
--- ## Parameters
--- * `word:` custom word to add to the dictionary.
--- 
--- Note:  
--- Available since Mudlet 3.18.
--- 
--- ## Example
--- ```lua
--- addWordToDictionary("Darkwind")
--- addWordToDictionary("黑暗的风")
--- addWordToDictionary("норм")
--- ```
--- 
--- ## Example - function making use of return value:
--- ```lua
--- function rememberPlayerName(name)
---   if addWordToDictionary(n) then
---     echo("Added '" .. n .. "' to dictionary...\n")
---   end
--- end
--- ```
function addWordToDictionary(word)
end

--- Returns the profile or shared custom dictionary word list (whichever is selected in preferences) - that is, words added via right-click "add word to dictionary" or [[#addWordToDictionary|addWordToDictionary()]].
--- 
---  Returns an indexed table of words.
--- 
--- Note:  
--- Available since Mudlet 3.18.
--- 
--- ## Example
--- ```lua
--- display(getDictionaryWordList())
--- ```
function getDictionaryWordList()
end

--- Removed the given word to the custom profile or shared dictionary (whichever is selected in preferences).
--- 
---  Returns true on success (if the word was present and removed by this call) and nil+msg on error.
--- 
--- See also:
--- see: addWordToDictionary()
--- ## Parameters
--- * `word:` custom word to remove from the dictionary.
--- 
--- Note:  
--- Available since Mudlet 3.18.
--- 
--- ## Example
--- ```lua
--- removeWordFromDictionary("Darkwind")
--- removeWordFromDictionary("黑暗的风")
--- removeWordFromDictionary("норм")
--- ```
function removeWordFromDictionary(word)
end

--- Spellchecks the given word against the custom or the system dictionary.
--- 
---  Returns true if the word is spelled correctly or false if it's not, and nil+msg on error.
--- 
--- See also:
--- see: addWordToDictionary()
--- see: removeWordFromDictionary()
--- see: spellSuggestWord()
--- ## Parameters
--- * `word`: word to spellcheck.
--- * `customDictionary` (optional): dictionary to use. If true, the profile or shared dictionary will be used (depending on your settings). If omitted or false, the system dictionary (the language you have selected in settings) will be used.
--- 
--- Note:  
--- Available since Mudlet 3.18.
--- 
--- ## Example
--- ```lua
--- -- spellcheck against the language dictionary
--- if spellCheckWord("run") then
---   echo("'run' is spelled ok!\n")
--- end
--- 
--- -- spellcheck against the custom 'add word to dictionary'
--- if spellCheckWord("Darkwind", true) then
---   echo("'Darkwind' is spelled OK!\n")
--- end
--- ```
function spellCheckWord(word, customDictionary)
end

--- Suggests similar words for the given word.
--- 
---  Returns a table of suggestions or nil+msg on error.
--- 
--- See also:
--- see: spellCheckWord()
--- ## Parameters
--- * `word`: word to give suggestions on.
--- * `customDictionary` (optional): dictionary to use. If true, the profile or shared dictionary will be used (depending on your settings). If omitted or false, the system dictionary (the language you have selected in settings) will be used.
--- 
--- Note:  
--- Available since Mudlet 3.18.
--- 
--- ## Example
--- ```lua
--- display(spellSuggestWord("Darkwind"))
--- ```
function spellSuggestWord(word, customDictionary)
end

--- ## <nowiki>mystring:byte([, i [, j]])</nowiki>
---  Returns the internal numerical codes of the characters <code>s[i], s[i+1], ···, s[j]</code>. The default value for <code>i</code> is <code>1</code>; the default value for <code>j</code> is <code>i</code>.
---  Note that numerical codes are not necessarily portable across platforms.
---  string.byte() works with English text only, use utf8.byte() for the international version.
--- See also:
--- see: string.char()
--- see: utf8.char()
--- ## Example
--- ```lua
--- -- the following call will return the ASCII values of "A", "B" and "C"
--- a, b, c = string.byte("ABC", 1, 3)
--- echo(a .. " - " .. b .. " - " .. c) -- shows "65 - 66 - 67"
--- 
--- -- same for the international version but with the Unicode values
--- a, b, c = utf8.byte("дом", 1, 3)
--- echo(a .. " - " .. b .. " - " .. c) -- shows "1076 - 1086 - 1084"
--- ```
function string.byte(string_, _i_, _j)_or_utf8.byte(string_, _i_, _j)
end

---  Receives zero or more integers. Returns a string with length equal to the number of arguments, in which each character has the internal numerical code equal to its corresponding argument.
---  Note that numerical codes are not necessarily portable across platforms.
---  string.char() works with English text only, use utf8.char() for the international version.
--- See also:
--- see: string.byte()
--- see: utf8.byte()
--- ## Example
--- ```lua
--- -- the following call will return the string "ABC" corresponding to the ASCII values 65, 66, 67
--- mystring = string.char(65, 66, 67)
--- 
--- -- same for the infernational version which will return text "дом" for the Unicode values 1076, 1086, 1084
--- mystring = utf8.char(1076,1086,1084)
--- print(mystring)
--- ```
function string.char(···)_or_utf8.char(···)
end

---  Cuts string to the specified maximum length.
---  Returns the modified string.
--- 
--- ## Parameters:
--- * `string:`
---  The text you wish to cut. Passed as a string.
--- * `maxLen:`
---  The maximum length you wish the string to be. Passed as an integer number.
--- 
--- ## Example
--- ```lua
--- --The following call will return 'abc' and store it in myString
--- myString = string.cut("abcde", 3)
--- --You can easily pad string to certain length. Example below will print 'abcde     ' e.g. pad/cut string to 10 characters.
--- local s = "abcde"
--- s = string.cut(s .. "          ", 10)   -- append 10 spaces
--- echo("'" .. s .. "'")
--- ```
function string.cut(string, maxLen)
end

--- Converts a function into a binary string.  You can use the loadstring() function later to get the function back.
---  string.dump() works with both English and non-English text fine.
--- ## Example
--- ```lua
--- string = string.dump(echo("this is a string"))
--- --The following should then echo "this is a string"
--- loadstring(string)()
--- ```
function string.dump()
end

---  Wraps a string with [[ ]]
---  Returns the altered string.
--- 
--- ## Parameters:
--- * `String:`
--- The string to enclose. Passed as a string.
--- 
--- ## Example
--- ```lua
--- --This will echo '[[Oh noes!]]' to the main window
--- echo("'" .. string.enclose("Oh noes!") .. "'")
--- ```
function string.enclose(string)
end

---  Test if string is ending with specified suffix.
---  Returns true or false.
--- See also:
--- see: string.starts()
--- ## Parameters:
--- * `String:`
---  The string to test. Passed as a string.
--- * `Suffix:`
---  The suffix to test for. Passed as a string.
--- 
--- ## Example
--- ```lua
--- --This will test if the incoming line ends with "in bed" and if not will add it to the end.
--- if not string.ends(line, "in bed") then
---   echo("in bed\n")
--- end
--- ```
function string.ends(String, Suffix)
end

---  Looks for the first match of pattern in the string text. If it finds a match, then find returns the indices of text where this occurrence starts and ends; otherwise, it returns nil. A third, optional numerical argument init specifies where to start the search; its default value is 1 and can be negative. A value of true as a fourth, optional argument plain turns off the pattern matching facilities, so the function does a plain "find substring" operation, with no characters in pattern being considered "magic". Note that if plain is given, then init must be given as well.
--- If the pattern has captures, then in a successful match the captured values are also returned, after the two indices.
---  string.find() works with English text only, use utf8.find() for the international version.
--- ## Example
--- <syntaxhighlight lang=lua>
--- -- check if the word appears in a variable
--- if string.find(matches[2], "rabbit") then
---   echo("Found a rabbit!\n")
--- end
--- 
--- -- the following example will print: "3, 4"
--- local start, stop = string.find("This is a test.", "is")
--- if start then
---    print(start .. ", " .. stop)
--- end
--- -- note that here "is" is being found at the end of the word "This", rather than the expected second word
--- 
--- -- to make it match the word on its own, prefix %f[%a] and suffix %f[%A]
--- if string.find("This is a test", "%f[%a]is%f[%A]") then
---   echo("This 'is' is the actual stand-alone word\n")
--- end
--- ```
--- * Return value:
---  nil or start and stop position of the first matched text, followed by any captured text.
function string.find(text, pattern_, _init_, _plain)_or_utf8.find()
end

---  Return first matching substring or nil.
--- 
--- ##  Parameters
--- * `text:`
---  The text you are searching the pattern for.
--- * `pattern:`
---  The pattern you are trying to find in the text.
--- 
--- ##  Example:
--- Following example will print: "I did find: Troll" string.
--- ```lua
--- local match = string.findPattern("Troll is here!", "Troll")
--- if match then
---    echo("I did find: " .. match)
--- end
--- ```
--- This example will find substring regardless of case.
--- ```lua
--- ocal match = string.findPattern("Troll is here!", string.genNocasePattern("troll"))
--- if match then
---     echo("I did find: " .. match)
--- end
--- ```
--- * Return value:
---  nil or first matching substring
--- See also:
--- see: string.genNocasePattern()
function string.findPattern(text, pattern)
end

---  Returns a formatted version of its variable number of arguments following the description given in its first argument (which must be a string). The format string follows the same rules as the printf family of standard C functions. The only differences are that the options/modifiers *, l, L, n, p, and h are not supported and that there is an extra option, q. The q option formats a string in a form suitable to be safely read back by the Lua interpreter: the string is written between double quotes, and all double quotes, newlines, embedded zeros, and backslashes in the string are correctly escaped when written. For instance, the call
--- <syntaxhighlight lang=lua>
--- string.format('%q', 'a string with "quotes" and \n new line')
--- ```
--- will produce the string:
--- <syntaxhighlight lang=lua>
---      "a string with \"quotes\" and \
---       new line"
--- ```
--- The options c, d, E, e, f, g, G, i, o, u, X, and x all expect a number as argument, whereas q and s expect a string.
--- 
--- This function does not accept string values containing embedded zeros, except as arguments to the q option.
--- 
--- string.format() works fine with both English and non-English text.
--- 
--- ## Example
--- <syntaxhighlight lang=lua>
--- some_data = "MudletUser1"
--- 
--- -- pad data 20 characters wide to the left
--- display(string.format("%20s", some_data))
--- -- result: "         MudletUser1"
--- 
--- -- pad same data but instead to the the right
--- display(string.format("%-20s", some_data))
--- -- result: "MudletUser1         "
--- 
--- -- pad but first truncate data to 6 characters
--- display(string.format("%20s", string.sub(some_data, 1, 6)))
--- -- result: "              Mudlet"
--- ```
function string.format(formatstring,...)
end

---  Generate case insensitive search pattern from string.
--- 
--- ##  Parameters
--- * template: The original string to be used as the base.
--- 
--- ##  Example:
--- ```lua
--- echo(string.genNocasePattern("123abc"))
--- -- result: "123[aA][bB][cC]"
--- ```
function string.genNocasePattern(template)
end

---  This is an old version of what is now string.gmatch. Use string.gmatch instead.
--- ## Example
--- `Need example`
function string.gfind()
end

---  Returns an iterator function that, each time it is called, returns the next captures from pattern over string text. If pattern specifies no captures, then the whole match is produced in each call.
--- As an example, the following loop
--- <syntaxhighlight lang=lua>
---      s = "hello world from Lua"
---      for w in string.gmatch(s, "%a+") do
---        print(w)
---      end```
--- will iterate over all the words from string s, printing one per line. The next example collects all pairs key=value from the given string into a table:
--- <syntaxhighlight lang=lua>
---      t = {}
---      s = "from=world, to=Lua"
---      for k, v in string.gmatch(s, "(%w+)=(%w+)") do
---        t[k] = v
---      end```
--- For this function, a '^' at the start of a pattern does not work as an anchor, as this would prevent the iteration.
---  string.gmatch() works with English text only, use utf8.gmatch() for the international version.
--- ## Example
--- `Need example`
function string.gmatch(text, pattern)_or_utf8.gmatch()
end

---  Returns a copy of text in which all (or the first n, if given) occurrences of the pattern have been replaced by a replacement string specified by repl, which can be a string, a table, or a function. gsub also returns, as its second value, the total number of matches that occurred.
--- 
--- If repl is a string, then its value is used for replacement. The character % works as an escape character: any sequence in repl of the form %n, with n between 1 and 9, stands for the value of the n-th captured substring (see below). The sequence %0 stands for the whole match. The sequence %% stands for a single %.
--- 
--- If repl is a table, then the table is queried for every match, using the first capture as the key; if the pattern specifies no captures, then the whole match is used as the key.
--- 
--- If repl is a function, then this function is called every time a match occurs, with all captured substrings passed as arguments, in order; if the pattern specifies no captures, then the whole match is passed as a sole argument.
--- 
--- If the value returned by the table query or by the function call is a string or a number, then it is used as the replacement string; otherwise, if it is false or nil, then there is no replacement (that is, the original match is kept in the string).
--- 
---  string.gsub() works with English text only, use utf8.gsub() for the international version.
--- ## Example
--- <syntaxhighlight lang=lua>
---      x = string.gsub("hello world", "(%w+)", "%1 %1")
---      --> x="hello hello world world"
---      
---      x = string.gsub("hello world", "%w+", "%0 %0", 1)
---      --> x="hello hello world"
---      
---      x = string.gsub("hello world from Lua", "(%w+)%s*(%w+)", "%2 %1")
---      --> x="world hello Lua from"
---      
---      x = string.gsub("home = $HOME, user = $USER", "%$(%w+)", os.getenv)
---      --> x="home = /home/roberto, user = roberto"
---      
---      x = string.gsub("4+5 = $return 4+5$", "%$(.-)%$", function (s)
---            return loadstring(s)()
---          end)
---      --> x="4+5 = 9"
---      
---      local t = {name="lua", version="5.1"}
---      x = string.gsub("$name-$version.tar.gz", "%$(%w+)", t)
---      --> x="lua-5.1.tar.gz"```
function string.gsub(text, pattern, repl_, _n)_or_utf8.gsub()
end

--- ## <nowiki>mystring:len()</nowiki>
--- Receives a string and returns its length. The empty string "" has length 0. Embedded zeros are counted, so "a\000bc\000" has length 5.
---  string.len() works with English text only, use utf8.len() for the international version.
--- 
--- ## Parameters:
--- * `string:`
--- The string (text) you want to find the length of.
--- 
--- ## Example
--- ```lua
--- -- prints 5 for the 5 letters in our word
--- print(string.len("hello"))
--- 
--- -- international version
--- print(utf8.len("слово"))
--- ```
function string.len(string)_or_utf8.len(string)
end

--- ## <nowiki>mystring:lower()</nowiki>
--- Receives a string and returns a copy of this string with all uppercase letters changed to lowercase. All other characters are left unchanged. The definition of what an uppercase letter is depends on the current locale.
---  string.lower() works with English text only, use utf8.lower() for the international version.
--- See also:
--- see: string.upper()
--- see: utf8.upper()
--- ## Example
--- ```lua
--- -- prints an all-lowercase version
--- print(string.lower("No way! This is AWESOME!"))
--- 
--- -- international version
--- print(utf8.lower("Класс! Ето ОТЛИЧНО!"))
--- ```
function string.lower(string)_or_utf8.lower(string)
end

---  Looks for the first match of pattern in the string text. If it finds one, then match returns the captures from the pattern; otherwise it returns nil. If pattern specifies no captures, then the whole match is returned. A third, optional numerical argument init specifies where to start the search; its default value is 1 and can be negative.
---  string.match() works with English text only, use utf8.match() for the international version.
--- ## Example
--- `Need example`
function string.match(text, pattern_, _init)_or_utf8.match()
end

--- ## <nowiki>mystring:rep(n)</nowiki>
---  Returns a string that is the concatenation of <code>n</code> copies of the string <code>String</code>.
---  string.rep() works with both English and non-English text fine.
--- 
--- ## Example
--- <syntaxhighlight lang=lua>
--- -- repeat * 10 times
--- display(string.rep("*", 10))
--- -- results in:
--- **********
--- 
--- -- do the same thing, but this time calling from a variable
--- s = "*"
--- display(s:rep(10))
--- -- results in:
--- **********
--- ```
function string.rep(String, n)
end

--- ## <nowiki>mystring:reverse()</nowiki>
--- 
---  Returns a string that is the string <code>string</code> reversed.
---  string.reverse() works with English text only, use utf8.reverse() for the international version.
--- 
--- ## Parameters:
--- * `string:`
--- The string to reverse. Passed as a string.
--- 
--- ## Example
--- ```lua
--- mystring = "Hello from Lua"
--- echo(mystring:reverse()) -- displays 'auL morf olleH'
--- 
--- -- international version.
--- mystring = "Привет от Луа!"
--- echo(utf8.reverse(mystring)) -- displays '!ауЛ то тевирП', which probably looks the same to you
--- ```
function string.reverse(string), utf8.reverse(string)
end

--- ## <nowiki>myString:split(delimiter)</nowiki>
---  Splits a string into a table by the given delimiter. Can be called against a string (or variable holding a string) using the second form above.
---  Returns a table containing the split sections of the string.
--- 
--- ## Parameters:
--- * `string:`
---  The string to split. Parameter is not needed if using second form of the syntax above. Passed as a string.
--- * `delimiter:`
---  The delimiter to use when splitting the string. Passed as a string, and allows for [http://www.lua.org/pil/20.2.html Lua pattern types]. Use % to escape here (and %% to escape a stand-alone %).
--- {{ Note }} as of Mudlet 4.7+, delimiter will default to " " if not provided.
--- 
--- {{ Note }} as of Mudlet 4.7+, using "" (empty string) for the delimiter will return the string as a table of characters. IE string.split("This","") will return as {"T", "h", "i", "s"}. Prior to 4.7 using empty string as the delimiter would error after hanging temporarily.
--- 
--- ## Example
--- ```lua
--- -- This will split the string by ", " delimiter and print the resulting table to the main window.
--- names = "Alice, Bob, Peter"
--- name_table = string.split(names, ", ")
--- display(name_table)
--- 
--- --The alternate method
--- names = "Alice, Bob, Peter"
--- name_table = names:split(", ")
--- display(name_table)
--- ```
--- 
--- Either method above will print out:
---     table {
---     1: 'Alice'
---     2: 'Bob'
---     3: 'Peter'
---     }
function string.split(string, delimiter)
end

---  Test if string is starting with specified prefix.
---  Returns true or false
--- See also:
--- see: string.ends()
--- ## Parameters:
--- * `string:`
---  The string to test. Passed as a string.
--- * `prefix:`
---  The prefix to test for. Passed as a string.
--- 
--- ## Example
--- ```lua
--- --The following will see if the line begins with "You" and if so will print a statement at the end of the line
--- if string.starts(line, "You") then
---   echo("====oh you====\n")
--- end
--- ```
function string.starts(string, prefix)
end

---  Returns the substring of text that starts at i and continues until j; i and j can be negative. If j is absent, then it is assumed to be equal to -1 (which is the same as the string length). In particular, the call string.sub(text,1,j) returns a prefix of text with length j, and string.sub(text, -i) returns a suffix of text with length i.
---  string.sub() works with English text only, use utf8.sub() for the international version.
--- ## Example
--- `Need example`
function string.sub(text, i_, _j)_or_utf8.sub()
end

--- ## <nowiki>mystring:title()</nowiki>
---  Capitalizes the first character in a string.
---  Returns the altered string.
--- 
--- ## Parameters:
--- * `string:`
---  The string to modify. Not needed if you use the second form of the syntax above.
--- 
--- ## Example
--- ```lua
--- --Variable testname is now Anna.
--- testname = string.title("anna")
--- --Example will set test to "Bob".
--- test = "bob"
--- test = test:title()
--- ```
function string.title(string)
end

---  Trims string, removing all 'extra' white space at the beginning and end of the text.
---  Returns the altered string.
--- 
--- ## Parameters:
--- * `string:`
---  The string to trim. Passed as a string.
--- 
--- ## Example:
--- ```lua
--- --This will print 'Troll is here!', without the extra spaces.
--- local str = string.trim("  Troll is here!  ")
--- echo("'" .. str .. "'")
--- ```
function string.trim(string)
end

--- ## <nowiki>mystring:upper()</nowiki>
---  Receives a string and returns a copy of this string with all lowercase letters changed to uppercase. All other characters are left unchanged. The definition of what a lowercase letter is depends on the current locale.
---  string.upper() works with English text only, use utf8.upper() for the international version.
--- 
--- See also:
--- see: string.lower()
--- see: utf8.lower()
--- ## Parameters
--- * `string:`
---  The string you want to change to uppercase
--- 
--- ## Example
--- ```lua
--- -- displays 'RUN BOB RUN'
--- print(string.upper("run bob run"))
--- 
--- -- displays 'ДАВАЙ ДАВАЙ!'
--- print(utf8.upper("давай давай!"))
--- ```
function string.upper(string)_or_utf8.upper(string)
end

---  Converts UTF-8 position to byte offset, returns the character position and code point. If only offset is given, returns byte offset of this UTF-8 char index. If charpos and offset is given, a new charpos will be calculated by adding/subtracting UTF-8 char offset to current charpos. In all cases, it return a new char position, and code point (a number) at this position.
--- 
--- ## Parameters
--- * `string:`
---  The input string to work on.
--- * `charpos:`
---  (optional) character position to work on.
--- * `offset:`
---  (optional) offset (as a number) to work on.
function utf8.charpos(string, , offset)
end

---  Escape a string to UTF-8 format string. It support several escape formats:
--- 
--- %ddd - which ddd is a decimal number at any length:
---        change Unicode code point to UTF-8 format.
--- %{ddd} - same as %nnn but has bracket around.
--- %uddd - same as %ddd, u stands Unicode
--- %u{ddd} - same as %{ddd}
--- %xhhh - hexadigit version of %ddd
--- %x{hhh} same as %xhhh.
--- %? - '?' stands for any other character: escape this character.
--- 
--- ## Parameters
--- * `string:`
---  The string you want to escape
--- 
--- ## Example
--- ```lua
--- local u = utf8.escape
--- print(u"%123%u123%{123}%u{123}%xABC%x{ABC}")
--- print(u"%%123%?%d%%u")
--- ```
function utf8.escape(string)
end

---  Returns the lowercase version of the string for use in case-insensitive comparisons. If string is a number, it's treated as a code point and the converted code point is returned (as a number).
--- 
--- ## Parameters
--- * `string:`
---  The string to lowercase.
--- 
--- ## Example
--- ```lua
--- print(utf8.fold("ПРИВЕТ")) -- 'привет'
--- print(utf8.fold("Привет")) -- 'привет'
--- ```
function utf8.fold(string)
end

---  Inserts the substring into the given string. If idx is given, inserts substring before the character at this index, otherwise the substring will append onto the end of string. idx can be negative.
--- 
--- ## Parameters
--- * `string:`
---  The input string to work on.
--- * `idx:`
---  (optional) character position to insert the string at.
--- * `substring:`
---  text to insert into the substring.
--- 
--- ## Example
--- ```lua
--- -- inserts letter я before the 2nd letter and prints 'мясо'
--- print(utf8.insert("мсо", 2, "я"))
--- ```
function utf8.insert(string, _idx, substring)
end

---  Compares `a` and `b` without case. Return -1 means a < b, 0 means a == b and 1 means a > b.
--- 
--- ## Parameters
--- * `a:`
---  String to compare.
--- * `b:`
---  String to compare against.
function utf8.ncasecmp(a, b)
end

---  Iterates though the UTF-8 string.
--- 
--- ## Parameters
--- * `string:`
---  The input string to work on.
--- * `charpos:`
---  (optional) character position to work on.
--- * `offset:`
---  (optional) offset (as a number) to work on.
--- 
--- ## Example
--- ```lua
--- -- prints location and code point of every letter
--- for pos, code in utf8.next, "тут есть текст" do
---    print(pos, code)
--- end
--- ```
function utf8.next(string, _charpos, _offset)
end

---  Removed characters from the given string. Deletes characters from the given `start` to the end of the string. If `stop` is given, deletes characters from `start` to `stop` (including start and stop). `start` and `stop` can be negative.
--- 
--- ## Parameters
--- * `string:`
---  The input string to work on.
--- * `start:`
---  position to start deleting characters from.
--- * `stop:`
---  (optional) posititon to stop deleting characters at.
--- 
--- ## Example
--- ```lua
--- -- delete everything from the 3rd character including the character itself
--- print(utf8.remove("мясо", 3)) -- 'мя'
--- 
--- -- delete the last character, use negative to count backwards
--- print(utf8.remove("мясо", -1)) -- 'мяс'
--- 
--- -- delete everything from the 2nd to the 4th character
--- print(utf8.remove("вкусное", 2,4)) -- 'вное'
--- ```
function utf8.remove(string, _start, _stop)
end

---  Returns the uppercase version of the string for use in case-insensitive comparisons. If string is a number, it's treated as a code point and the converted code point is returned (as a number).
--- 
--- ## Parameters
--- * `string:`
---  The string to uppercase.
--- 
--- ## Example
--- ```lua
--- print(utf8.title("привет")) -- 'ПРИВЕТ'
--- print(utf8.title("Привет")) -- 'ПРИВЕТ'
--- ```
function utf8.title(string)
end

---  Calculate the widths of the given string. If the string is a code point, return the width of this code point.
--- 
--- ## Parameters
--- * `string:`
---  The input string to work on.
--- * `ambi_is_double:`
---  (optional) if provided, the ambiguous width character's width is 2, otherwise it's 1.
--- * `default_width:`
---  (optional) if provided, this will be the width of unprintable character, used display a non-character mark for these characters.
function utf8.width(string, _ambi_is_double, _default_width)
end

---  Returns the character index at the location in the given string as well as the offset and the width. This is a reverse operation of utf8.width().
--- 
--- ## Parameters
--- * `string:`
---  The input string to work on.
--- * `location:`
---  location to get the width of.
--- * `ambi_is_double:`
---  (optional) if provided, the ambiguous width character's width is 2, otherwise it's 1.
--- * `default_width:`
---  (optional) if provided, this will be the width of unprintable character, used display a non-character mark for these characters.
function utf8.widthindex(string, location, _ambi_is_double, _default_width)
end

