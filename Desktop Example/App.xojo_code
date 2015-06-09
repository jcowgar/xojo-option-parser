#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Open()
		  MsgBox "Command line: " + EndOfLine + EndOfLine + System.CommandLine
		  
		  dim args() as string = OptionParser.CommandLineArgs
		  
		  dim parser as new OptionParser("Example", "")
		  parser.AddOption new Option("s", "something", "")
		  parser.AddOption new Option("", "somethingelse", "")
		  
		  parser.Parse args
		  
		  if parser.OptionValue("s").WasSet then
		    MsgBox "'Something' was set to " + parser.OptionValue("s").Value
		  end if
		  
		End Sub
	#tag EndEvent


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


End Class
#tag EndClass
