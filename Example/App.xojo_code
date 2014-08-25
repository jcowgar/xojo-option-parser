#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  ParseOptions(args)
		  
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
		Private Sub ParseOptions(args() As String)
		  Dim o As Option
		  
		  Options = New OptionParser(kAppName, kAppDescription)
		  
		  Options.AddOption New Option("t", "test", "Run unit tests", Option.OptionType.Boolean)
		  
		  o = New Option("p", "person", "Person to talk to")
		  o.IsRequired = True
		  Options.AddOption o
		  
		  Options.AddOption New Option("m", "say-goodmorning", "Say goodmorning to person", Option.OptionType.Boolean)
		  Options.AddOption New Option("n", "say-goodnight", "Say goodnight to person", Option.OptionType.Boolean)
		  Options.AddOption New Option("o", "say-other", "Say some other message to person")
		  
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
		  Dim controller As New ConsoleTestController
		  controller.LoadTestGroups
		  
		  // Run Tests
		  Print "Running Tests..."
		  controller.Start
		  
		  Dim testCount As Integer
		  testCount = controller.RunTestCount
		  
		  Dim now As New Date
		  
		  Print "Start: " + now.ShortDate + " " + now.ShortTime
		  Print "Duration: " + Format(controller.Duration, "#,###.0000000") + "s"
		  Print "Total: " + Str(testCount) + " tests in " + Str(controller.GroupCount) + " groups were run."
		  Print "Passed: " + Str(controller.PassedCount) + " (" + Format((controller.PassedCount / testCount) * 100, "##.00") + "%)"
		  Print "Failed: " + Str(controller.FailedCount) + " (" + Format((controller.FailedCount / testCount) * 100, "##.00") + "%)"
		  Print "Skipped: " + Str(controller.SkippedCount)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Options As OptionParser
	#tag EndProperty


	#tag Constant, Name = kAppDescription, Type = String, Dynamic = False, Default = \"Example use of the option parser classes", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kAppName, Type = String, Dynamic = False, Default = \"option-parser-example", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
