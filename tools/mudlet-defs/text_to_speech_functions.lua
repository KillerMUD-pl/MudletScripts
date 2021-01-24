---  This function will help, if you have already queued a few lines of text to speak, and now want to remove some or all of them.
---  Returns false if an invalid index is given. 
--- 
--- See also:
--- see: ttsGetQueue()
--- see: ttsQueue()
--- ## Parameters
--- * `index`:
---  (optional) number. The text at this index position of the queue will be removed. If no number is given, the whole queue is cleared.
--- 
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- -- queue five words and then remove some, "one, two, four" will be actually said
--- ttsQueue("One")
--- ttsQueue("Two")
--- ttsQueue("Three")
--- ttsQueue("Four")
--- ttsQueue("Five")
--- ttsClearQueue(2)
--- ttsClearQueue(3)
--- 
--- -- clear the whole queue entirely
--- ttsClearQueue()
--- ```
function ttsClearQueue(index)
end

---  If you want to analyse if or what is currently said, this function is for you.
---  Returns the text being spoken, or false if not speaking.
--- 
--- See also:
--- see: ttsSpeak()
--- see: ttsQueue()
--- Note:  Available since Mudlet 3.17
--- 
--- 
--- ```lua
--- ttsQueue("One")
--- ttsQueue("Two")
--- ttsQueue("Three")
--- ttsQueue("Four")
--- ttsQueue("Five")
--- 
--- -- print the line currently spoken 1s and 3s after which will be "two" and "five"
--- tempTimer(1, function()
---   echo("Speaking: ".. ttsGetCurrentLine().."\n")
--- end)
--- 
--- tempTimer(3, function()
---   echo("Speaking: ".. ttsGetCurrentLine().."\n")
--- end)
--- ```
function ttsGetCurrentLine()
end

---  If you have multiple voices available on your system, you may want to check which one is currently in use.
---  Returns the name of the voice used for speaking.
--- 
--- See also:
--- see: ttsGetVoices()
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- -- for example returns "Microsoft Zira Desktop" on Windows (US locale)
--- display(ttsGetCurrentVoice())
--- ```
function ttsGetCurrentVoice()
end

---  This function can be used to show your current queue of texts, or any single text thereof.
---  Returns a single text or a table of texts, or false. See index parameter for details.
--- 
--- See also:
--- see: ttsQueue()
--- ## Parameters
--- * `index`
---  (optional) number. The text at this index position of the queue will be returned. If no index is given, the whole queue will be returned. If the given index does not exist, the function returns false.
--- 
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- ttsQueue("We begin with some text")
--- ttsQueue("And we continue it without interruption")
--- display(ttsGetQueue())
--- -- will show the queued texts as follows
--- -- (first line ignored because it's being spoken and is not in queue):
--- -- {
--- --   "And we continue it without interruption"
--- -- }
--- ```
function ttsGetQueue(index)
end

---  With this function you can find the current state of the speech engine.
---  Returns one of: ttsSpeechReady, ttsSpeechPaused, ttsSpeechStarted, ttsSpeechError, ttsUnknownState. 
--- 
--- See also:
--- see: ttsSpeak()
--- see: ttsPause()
--- see: ttsResume()
--- see: ttsQueue()
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- ttsQueue("We begin with some text")
--- ttsQueue("And we continue it without interruption")
--- echo(ttsGetState())
--- -- ttsSpeechStarted
--- ```
function ttsGetState()
end

---  Lists all voices available to your current operating system and language settings. Currently uses the default system locale.
---  Returns a table of names. 
--- 
--- See also:
--- see: ttsGetCurrentVoice()
--- see: ttsSetVoiceByName()
--- see: ttsSetVoiceByIndex()
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- display(ttsGetVoices())
--- -- for example returns the following on Windows (US locale)
--- -- {
--- --   "Microsoft Zira Desktop"
--- -- }
--- ```
function ttsGetVoices()
end

---  Pauses the speech which is currently spoken, if any. Engines on different OS's (Windows/macOS/Linux) behave differently - pause may not work at all, it may take several seconds before it takes effect, or it may pause instantly. Some engines will look for a break that they can later resume from, such as a sentence end.
--- 
--- See also:
--- see: ttsResume()
--- see: ttsQueue()
--- Note:  Available since Mudlet 3.17
--- 
--- ```lua
--- -- set some text to be spoken, pause it 2s later, and unpause 4s later
--- ttsSpeak("Sir David Frederick Attenborough is an English broadcaster and naturalist. He is best known for writing and presenting, in conjunction with the BBC Natural History Unit, the nine natural history documentary series that form the Life collection, which form a comprehensive survey of animal and plant life on Earth. Source: Wikipedia")
--- tempTimer(2, function() ttsPause() end)
--- 
--- tempTimer(2, function() ttsResume() end)
--- ```
function ttsPause()
end

---  This function will add the given text to your speech queue. Text from the queue will be spoken one after the other. This is opposed to ttsSpeak which will interrupt any spoken text immediately. The queue can be reviewed and modified, while their content has not been spoken.
--- 
--- See also:
--- see: ttsGetQueue()
--- see: ttsPause()
--- see: ttsResume()
--- see: ttsClearQueue()
--- see: ttsGetState()
--- see: ttsSpeak()
--- ## Parameters
--- * text to queue:
---  Any written text which you would like to hear spoken to you. You can write literal text, or put in string variables, maybe taken from triggers or aliases, etc.
--- * `index`
---  (optional) number. The text will be inserted to the queue at this index position. If no index is provided, the text will be added to the end of the queue.
--- 
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- ttsQueue("We begin with some text")
--- ttsQueue("And we continue it without interruption")
--- display(ttsGetQueue())
--- -- will show the queued texts as follows
--- -- (first line ignored because it's being spoken and is not in queue):
--- -- {
--- --   "And we continue it without interruption"
--- -- }
--- ```
function ttsQueue(text_to_queue, index)
end

---  Resumes the speech which was previously spoken, if any has been paused.
--- 
--- See also:
--- see: ttsPause()
--- see: ttsQueue()
--- Note:  Available since Mudlet 3.17
--- 
--- ```lua
--- -- set some text to be spoken, pause it 2s later, and unpause 4s later
--- ttsSpeak("Sir David Frederick Attenborough is an English broadcaster and naturalist. He is best known for writing and presenting, in conjunction with the BBC Natural History Unit, the nine natural history documentary series that form the Life collection, which form a comprehensive survey of animal and plant life on Earth. Source: Wikipedia")
--- tempTimer(2, function() ttsPause() end)
--- 
--- tempTimer(2, function() ttsResume() end)
--- ```
function ttsResume()
end

---  This will speak the given text immediately with the currently selected voice. Any currently spoken text will be interrupted (use the speech queue to queue a voice instead).
--- 
--- See also:
--- see: ttsQueue()
--- ## Parameters
--- * text to speak:
---  Any written text which you would like to hear spoken to you. You can write literal text, or put in string variables, maybe taken from triggers or aliases, etc.
--- 
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- ttsSpeak("Hello World!")
--- 
--- -- if 'target' is your target variable, you can also do this:
--- ttsSpeak("Hello "..target)
--- ```
function ttsSpeak(text_to_speak)
end

---  Sets the pitch of speech playback.
--- 
--- ## Parameters
--- * pitch:
---  Number. Should be between 1 and -1, will be limited otherwise.
--- 
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- -- talk deeply first, after 2 seconds talk highly, after 4 seconds normally again
--- ttsSetPitch(-1)
--- ttsQueue("Deep voice")
--- 
--- tempTimer(2, function()
---   ttsSetPitch(1)
---   ttsQueue("High voice")
--- end)
--- 
--- tempTimer(4, function()
---   ttsSetPitch(0)
---   ttsQueue("Normal voice")
--- end)
--- ```
function ttsSetPitch(pitch)
end

---  Sets the rate of speech playback.
--- 
--- ## Parameters
--- * rate:
---  Number. Should be between 1 and -1, will be limited otherwise.
--- 
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- -- talk slowly first, after 2 seconds talk quickly, after 4 seconds normally again
--- ttsSetRate(-1)
--- ttsQueue("Slow voice")
--- 
--- tempTimer(2, function ()
---   ttsSetRate(1)
---   ttsQueue("Quick voice")
--- end)
--- 
--- tempTimer(4, function ()
---   ttsSetRate(0)
---  ttsQueue("Normal voice")
--- end)
--- ```
function ttsSetRate(rate)
end

---  Sets the volume of speech playback.
--- 
--- ## Parameters
--- * volume:
---  Number. Should be between 1 and 0, will be limited otherwise.
--- 
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- -- talk quietly first, after 2 seconds talk a bit louder, after 4 seconds normally again
--- ttsSetVolume(0.2)
--- ttsSpeak("Quiet voice")
--- 
--- tempTimer(2, function ()
---   ttsSetVolume(0.5)
---   ttsSpeak("Low voice")
--- end)
--- 
--- tempTimer(4, function () 
---   ttsSetVolume(1)
---   ttsSpeak("Normal voice")
--- end)
--- ```
function ttsSetVolume(volume)
end

---  If you have multiple voices available, you can switch them with this function by giving their index position as seen in the table you receive from ttsGetVoices(). If you know their name, you can also use ttsSetVoiceByName.
---  Returns true, if the setting was successful, errors otherwise. 
--- 
--- See also:
--- see: ttsGetVoices()
--- ## Parameters
--- * index:
---  Number. The voice from this index position of the ttsGetVoices table will be set. 
--- 
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- display(ttsGetVoices())
--- ttsSetVoiceByIndex(1)
--- ```
function ttsSetVoiceByIndex(index)
end

---  If you have multiple voices available, and know their name already, you can switch them with this function.
---  Returns true, if the setting was successful, false otherwise. 
--- 
--- See also:
--- see: ttsGetVoices()
--- ## Parameters
--- * name:
---  Text. The voice with this exact name will be set.
--- 
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- display(ttsGetVoices())
--- ttsSetVoiceByName("Microsoft Zira Desktop") -- example voice on Windows
--- ```
function ttsSetVoiceByName(name)
end

---  Skips the current line of text.
--- 
--- See also:
--- see: ttsPause()
--- see: ttsQueue()
--- Note:  Available since Mudlet 3.17
--- 
--- ## Example
--- ```lua
--- ttsQueue("We hold these truths to be self-evident")
--- ttsQueue("that all species are created different but equal")
--- ttsQueue("that they are endowed with certain unalienable rights")
--- tempTimer(2, function () ttsSkip() end)
--- ```
function ttsSkip()
end

