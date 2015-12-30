#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  ParseOptions(args)
		  if Options.HelpRequested then
		    Options.ShowHelp
		    return 0
		  end if
		  
		  If Options.BooleanValue("test") Then
		    RunUnitTests
		    
		  Else
		    Dim person As String = Options.StringValue("person")
		    Dim count As Integer = Options.IntegerValue("count", 1)
		    Dim lines() As String
		    
		    For i As Integer = 1 To count
		      If Options.BooleanValue("say-goodmorning") Then
		        lines.Append "Goodmorning " + person + "!"
		      End If
		      
		      If Options.BooleanValue("say-goodnight") Then
		        lines.Append "Goodnight " + person + "!"
		      End If
		      
		      If Options.OptionValue("say-other").WasSet Then
		        lines.Append Options.StringValue("say-other") + " " + person + "!"
		      End If
		    Next
		    
		    Dim totalMessage As String = Join(lines, EndOfLine)
		    
		    If Not (Options.FileValue("file") Is Nil) Then
		      Dim tos As TextOutputStream = TextOutputStream.Create(Options.FileValue("file"))
		      tos.Write totalMessage
		      
		    Else
		      Print totalMessage
		    End If
		  End If
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub FilterTests()
		  // Filter the tests based on the Include and Exclude options
		  
		  Dim includeOption As Option = Options.OptionValue(kOptionInclude)
		  Dim excludeOption As Option = Options.OptionValue(kOptionExclude)
		  
		  If includeOption.WasSet Or excludeOption.WasSet Then
		    Print "Filtering Tests..."
		  Else
		    Return
		  End If
		  
		  Dim includes() As String
		  If Not includeOption.Value.IsNull Then
		    Dim v() As Variant = includeOption.Value
		    For Each pattern As String In v
		      includes.Append pattern
		    Next
		  End If
		  
		  Dim excludes() As String
		  If not excludeOption.Value.IsNull Then
		    Dim v() As Variant = excludeOption.Value
		    For Each pattern As String In v
		      excludes.Append pattern
		    Next
		  End If
		  
		  Controller.FilterTests(includes, excludes)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function OutputResults() As FolderItem
		  Const kIndent = "   "
		  
		  Dim outputFile As FolderItem
		  If Options.Extra.Ubound = -1 Then
		    outputFile = GetFolderItem(kDefaultExportFileName)
		  Else
		    outputFile = GetFolderItem(Options.Extra(0), FolderItem.PathTypeNative)
		    If outputFile.Directory Then
		      outputFile = outputFile.Child(kDefaultExportFileName)
		    End If
		  End If
		  
		  Dim output As TextOutputStream
		  
		  output = TextOutputStream.Create(outputFile)
		  
		  Dim testCount As Integer
		  testCount = Controller.RunTestCount
		  
		  Dim now As New Date
		  
		  output.WriteLine("Start: " + now.ShortDate + " " + now.ShortTime)
		  output.WriteLine("Duration: " + Format(Controller.Duration, "#,###.0000000") + "s")
		  output.WriteLine("Total: " + Str(testCount) + " tests in " + Str(Controller.GroupCount) + " groups were run.")
		  output.WriteLine("Passed: " + Str(Controller.PassedCount) + " (" + Format((Controller.PassedCount / testCount) * 100, "##.00") + "%)")
		  output.WriteLine("Failed: " + Str(Controller.FailedCount) + " (" + Format((Controller.FailedCount / testCount) * 100, "##.00") + "%)")
		  output.WriteLine("Skipped: " + Str(Controller.SkippedCount))
		  output.WriteLine("")
		  
		  For Each tg As TestGroup In Controller.TestGroups
		    output.WriteLine(tg.Name)
		    
		    For Each tr As TestResult In tg.Results
		      output.WriteLine(kIndent + tr.TestName + ": " + tr.Result + " (" + Format(tr.Duration, "#,###.0000000") + "s)")
		      If tr.Message <> "" Then
		        output.WriteLine(kIndent + kIndent + tr.Message)
		      End If
		    Next
		  Next
		  
		  output.Close
		  
		  Return outputFile
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseOptions(args() As String)
		  Dim o As Option
		  
		  Options = New OptionParser(kAppName, kAppDescription)
		  
		  Options.AddOption New Option("t", "test", "Run unit tests", Option.OptionType.Boolean)
		  
		  o = New Option("i", kOptionInclude, "Include a Group[.Method] (* is wildcard)", Option.OptionType.String)
		  o.IsArray = True
		  Options.AddOption o
		  
		  o = New Option("x", kOptionExclude, "Exclude a Group[.Method] (* is wildcard)", Option.OptionType.String)
		  o.IsArray = True
		  Options.AddOption o
		  
		  Options.AdditionalHelpNotes = "If an export path is not specified, a default file named `" + kDefaultExportFileName + _
		  "' will be created next to the app. If the path is a directory, a file of that name will be created within it."
		  
		  //
		  // Test options
		  //
		  
		  o = New Option("p", "person", "Person to talk to")
		  o.IsRequired = True
		  o.AddDisallowedValue("tommy tune")
		  Options.AddOption o
		  
		  Options.AddOption New Option("m", "say-goodmorning", "Say goodmorning to person", Option.OptionType.Boolean)
		  Options.AddOption New Option("n", "say-goodnight", "Say goodnight to person", Option.OptionType.Boolean)
		  Options.AddOption New Option("o", "say-other", "Say some other message to person")
		  Options.OptionValue("o").AddAllowedValue("hello", "howdy", "goodbye")
		  
		  o = New Option("c", "count", "Number of times to perform the action", Option.OptionType.Integer)
		  o.MinimumNumber = 1
		  o.MaximumNumber = 10
		  Options.AddOption o
		  
		  o = New Option("f", "file", "Output message to FILE", Option.OptionType.File)
		  o.IsWriteableRequired = True
		  Options.AddOption o
		  
		  Try
		    Options.Parse(args)
		    
		  Catch OptionMissingKeyException
		    Print "Invalid usage"
		    Print ""
		    
		    Options.ShowHelp
		    
		    Quit 1
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RunUnitTests()
		  // Initialize Groups
		  Print "Initializing Test Groups..."
		  Controller = New ConsoleTestController
		  Controller.LoadTestGroups
		  
		  // Filter Tests
		  FilterTests
		  
		  // Run Tests
		  Print "Running Tests..."
		  Controller.Start
		  
		  // Output Results
		  Print "Saving Results..."
		  
		  Dim outputFile As FolderItem
		  outputFile = OutputResults
		  
		  Dim testCount As Integer
		  testCount = Controller.RunTestCount
		  
		  Dim now As New Date
		  
		  Print "Start: " + now.ShortDate + " " + now.ShortTime
		  Print "Duration: " + Format(Controller.Duration, "#,###.0000000") + "s"
		  Print "Total: " + Str(testCount) + " tests in " + Str(Controller.GroupCount) + " groups were run."
		  Print "Passed: " + Str(Controller.PassedCount) + " (" + Format((Controller.PassedCount / testCount) * 100, "##.00") + "%)"
		  Print "Failed: " + Str(Controller.FailedCount) + " (" + Format((Controller.FailedCount / testCount) * 100, "##.00") + "%)"
		  Print "Skipped: " + Str(Controller.SkippedCount)
		  Print "Results file: " + outputFile.NativePath
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Controller As ConsoleTestController
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Options As OptionParser
	#tag EndProperty


	#tag Constant, Name = kAppDescription, Type = String, Dynamic = False, Default = \"Example use of the option parser classes", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kAppName, Type = String, Dynamic = False, Default = \"option-parser-example", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDefaultExportFileName, Type = String, Dynamic = False, Default = \"XojoUnitResults.txt", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionExclude, Type = String, Dynamic = False, Default = \"exclude", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionInclude, Type = String, Dynamic = False, Default = \"include", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
