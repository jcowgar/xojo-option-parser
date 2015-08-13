#tag Class
Protected Class OptionParserTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub FirstArgumentTest()
		  dim parser as new OptionParser
		  parser.AddOption new Option("", "test", "Tester", Option.OptionType.Boolean)
		  
		  dim args() as string = Array("executable", "--test")
		  
		  parser.Parse(args)
		  Assert.AreEqual(-1, parser.Extra.Ubound)
		  Assert.IsTrue(parser.BooleanValue("test"))
		  
		  parser.Parse args, false
		  Assert.AreEqual(0, parser.Extra.Ubound)
		  Assert.IsTrue(parser.BooleanValue("test"))
		  Assert.AreEqual("executable", parser.Extra(0))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LongKeyNoBooleanTest()
		  Dim o As New OptionParser("app", "desc")
		  
		  Assert.AreEqual("app", o.AppName)
		  Assert.AreEqual("desc", o.AppDescription)
		  
		  o.AddOption New Option("a", "abc", "ABC setting")
		  o.AddOption New Option("b", "bcd", "BCD setting", Option.OptionType.Boolean)
		  o.AddOption New Option("c", "cde", "CDE setting", Option.OptionType.Boolean)
		  o.Parse(Array("--abc=JOHN", "--no-bcd", "--cde"), false)
		  
		  Assert.AreEqual("JOHN", o.StringValue("abc"), "abc param")
		  Assert.IsFalse(o.BooleanValue("bcd"), "bcd param")
		  Assert.IsTrue(o.BooleanValue("cde"), "cde param")
		  
		  Assert.IsTrue(o.OptionValue("abc").WasSet, "abc was set?")
		  Assert.IsTrue(o.OptionValue("bcd").WasSet, "bcd was set?")
		  Assert.IsTrue(o.OptionValue("cde").WasSet, "cde was set?")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LongKeyTest()
		  Dim o As New OptionParser("app", "desc")
		  
		  Assert.AreEqual("app", o.AppName)
		  Assert.AreEqual("desc", o.AppDescription)
		  
		  o.AddOption New Option("a", "abc", "ABC setting")
		  o.AddOption New Option("b", "bcd", "BCD setting", Option.OptionType.Boolean)
		  o.AddOption New Option("c", "cde", "CDE setting", Option.OptionType.Boolean)
		  o.Parse(Array("--abc=JOHN", "--bcd=No", "--cde=Yes"), false)
		  
		  Assert.AreEqual("JOHN", o.StringValue("abc"), "abc param")
		  Assert.IsFalse(o.BooleanValue("bcd"), "bcd param")
		  Assert.IsTrue(o.BooleanValue("cde"), "cde param")
		  
		  Assert.IsTrue(o.OptionValue("abc").WasSet, "abc was set?")
		  Assert.IsTrue(o.OptionValue("bcd").WasSet, "bcd was set?")
		  Assert.IsTrue(o.OptionValue("cde").WasSet, "cde was set?")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetToEmptyTest()
		  Dim o As New OptionParser("app", "desc")
		  o.AddOption new Option("", "set", "", Option.OptionType.String)
		  
		  o.Parse array("--set", ""), false
		  Assert.IsTrue o.OptionValue("set").WasSet
		  Assert.AreEqual "", o.StringValue("set")
		  
		  o.Parse array("--set="), false
		  Assert.IsTrue o.OptionValue("set").WasSet
		  Assert.AreEqual "", o.StringValue("set")
		  
		  o = new OptionParser("app", "desc")
		  o.AddOption new Option("", "set", "", Option.OptionType.File)
		  
		  o.Parse array("--set", ""), false
		  Assert.IsTrue o.OptionValue("set").WasSet
		  Assert.IsNil o.FileValue("set")
		  
		  o.Parse array("--set="), false
		  Assert.IsTrue o.OptionValue("set").WasSet
		  Assert.IsNil o.FileValue("set")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShortKeyRunTest()
		  Dim o As New OptionParser("app", "desc")
		  
		  Assert.AreEqual("app", o.AppName)
		  Assert.AreEqual("desc", o.AppDescription)
		  
		  o.AddOption New Option("a", "abc", "ABC setting")
		  o.AddOption New Option("b", "bcd", "BCD setting", Option.OptionType.Boolean)
		  o.AddOption New Option("c", "cde", "CDE setting", Option.OptionType.Boolean)
		  o.Parse(Array("-bc", "-a", "JOHN"), false)
		  
		  Assert.AreEqual("JOHN", o.StringValue("abc"), "abc param")
		  Assert.IsTrue(o.BooleanValue("bcd"), "bcd param")
		  Assert.IsTrue(o.BooleanValue("cde"), "cde param")
		  
		  Assert.IsTrue(o.OptionValue("abc").WasSet, "abc was set?")
		  Assert.IsTrue(o.OptionValue("bcd").WasSet, "bcd was set?")
		  Assert.IsTrue(o.OptionValue("cde").WasSet, "cde was set?")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShortKeyRunWithValueTest()
		  Dim o As New OptionParser("app", "desc")
		  
		  Assert.AreEqual("app", o.AppName)
		  Assert.AreEqual("desc", o.AppDescription)
		  
		  o.AddOption New Option("a", "abc", "ABC setting")
		  o.AddOption New Option("b", "bcd", "BCD setting", Option.OptionType.Boolean)
		  o.AddOption New Option("c", "cde", "CDE setting", Option.OptionType.Boolean)
		  o.Parse(Array("-bca", "JOHN"), false)
		  
		  Assert.AreEqual("JOHN", o.StringValue("abc"), "abc param")
		  Assert.IsTrue(o.BooleanValue("bcd"), "bcd param")
		  Assert.IsTrue(o.BooleanValue("cde"), "cde param")
		  
		  Assert.IsTrue(o.OptionValue("abc").WasSet, "abc was set?")
		  Assert.IsTrue(o.OptionValue("bcd").WasSet, "bcd was set?")
		  Assert.IsTrue(o.OptionValue("cde").WasSet, "cde was set?")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShortKeyWithEqualTest()
		  Dim o As New OptionParser("app", "desc")
		  
		  Assert.AreEqual("app", o.AppName)
		  Assert.AreEqual("desc", o.AppDescription)
		  
		  o.AddOption New Option("a", "abc", "ABC setting")
		  o.AddOption New Option("b", "bcd", "BCD setting", Option.OptionType.Boolean)
		  o.AddOption New Option("c", "cde", "CDE setting", Option.OptionType.Boolean)
		  o.Parse(Array("-a=JOHN", "-b=Yes", "-c=No"), false)
		  
		  Assert.AreEqual("JOHN", o.StringValue("abc"), "abc param")
		  Assert.IsTrue(o.BooleanValue("bcd"), "bcd param")
		  Assert.IsFalse(o.BooleanValue("cde"), "cde param")
		  
		  Assert.IsTrue(o.OptionValue("abc").WasSet, "abc was set?")
		  Assert.IsTrue(o.OptionValue("bcd").WasSet, "bcd was set?")
		  Assert.IsTrue(o.OptionValue("cde").WasSet, "cde was set?")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SimpleTest()
		  Dim o As New OptionParser("app", "desc")
		  
		  Assert.AreEqual("app", o.AppName)
		  Assert.AreEqual("desc", o.AppDescription)
		  
		  o.AddOption New Option("a", "abc", "ABC setting")
		  o.AddOption New Option("b", "bcd", "BCD setting", Option.OptionType.Boolean)
		  o.AddOption New Option("c", "cde", "CDE setting", Option.OptionType.Boolean)
		  
		  o.Parse(Array("-a", "JOHN", "-b"), false)
		  
		  Assert.AreEqual("JOHN", o.StringValue("abc"))
		  Assert.IsTrue(o.BooleanValue("bcd"))
		  Assert.IsFalse(o.BooleanValue("cde"))
		  Assert.IsTrue(o.BooleanValue("cde", True))
		  
		  Assert.IsTrue(o.OptionValue("abc").WasSet)
		  Assert.IsTrue(o.OptionValue("bcd").WasSet)
		  Assert.IsFalse(o.OptionValue("cde").WasSet)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StopProcessingArgumentsTest()
		  Dim p As New OptionParser
		  
		  p.AddOption New Option("a", "abc", "ABC")
		  p.AddOption New Option("b", "bcd", "BCD")
		  
		  p.Parse(Array("-a", "john", "--", "-b", "jeff"), false)
		  
		  Assert.AreEqual("john", p.StringValue("abc"))
		  Assert.AreEqual("", p.StringValue("bcd"))
		  Assert.AreEqual("-b", p.Extra(0))
		  Assert.AreEqual("jeff", p.Extra(1))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ValidationFailTest()
		  Dim o As New OptionParser("app", "desc")
		  
		  Assert.AreEqual("app", o.AppName)
		  Assert.AreEqual("desc", o.AppDescription)
		  
		  Dim opt As Option
		  
		  opt = New Option("", "date", "Date", Option.OptionType.Date)
		  opt.IsValidDateRequired = True
		  o.AddOption opt
		  
		  Dim caughtError As Boolean = False
		  
		  #Pragma BreakOnExceptions False
		  Try
		    o.Parse(Array("--date=john"), false)
		  Catch RuntimeException
		    caughtError = True
		  End Try
		  #Pragma BreakOnExceptions True
		  
		  Assert.IsTrue(caughtError, "did date validation fail?")
		  
		  o = New OptionParser("app", "desc")
		  opt = New Option("", "int", "Integer", Option.OptionType.Integer)
		  opt.MinimumNumber = 10
		  opt.MaximumNumber = 20
		  o.AddOption opt
		  
		  caughtError = False
		  
		  #Pragma BreakOnExceptions False
		  Try
		    o.Parse(Array("--int=3"), false)
		  Catch RuntimeException
		    caughtError = True
		  End Try
		  #Pragma BreakOnExceptions True
		  
		  Assert.IsTrue(caughtError, "did integer validation fail?")
		  
		  caughtError = False
		  
		  #Pragma BreakOnExceptions False
		  Try
		    o.AddOption New Option("", "", "no keys", Option.OptionType.Boolean)
		  Catch
		    caughtError = True
		  End Try
		  #Pragma BreakOnExceptions True
		  
		  Assert.IsTrue(caughtError, "supplying no keys did not fail.")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ValidationPassTest()
		  Dim o As New OptionParser("app", "desc")
		  
		  Assert.AreEqual("app", o.AppName)
		  Assert.AreEqual("desc", o.AppDescription)
		  
		  Dim opt As Option
		  
		  opt = New Option("", "date", "Date", Option.OptionType.Date)
		  opt.IsValidDateRequired = True
		  o.AddOption opt
		  
		  opt = New Option("", "file", "File", Option.OptionType.File)
		  opt.IsReadableRequired = True
		  o.AddOption opt
		  
		  opt = New Option("", "dir", "Dir", Option.OptionType.Directory)
		  opt.IsWriteableRequired = True
		  o.AddOption opt
		  
		  opt = New Option("", "int", "Integer", Option.OptionType.Integer)
		  opt.MinimumNumber = 10
		  opt.MaximumNumber = 20
		  o.AddOption opt
		  
		  opt = New Option("", "dbl", "Double", Option.OptionType.Double)
		  opt.MinimumNumber = 10
		  opt.MaximumNumber = 20
		  o.AddOption opt
		  
		  Dim fi As FolderItem = App.ExecutableFile
		  
		  o.Parse(Array("--date=01/15/2014", "--file=" + fi.ShellPath, "--dir=" + fi.Parent.ShellPath, _
		  "--int=15", "--dbl=19.94"), false)
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
