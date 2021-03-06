#tag Class
Protected Class OptionTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub AllowedAndDisallowedTest()
		  // Makes sure that we can't add the same value as both allowed and disallowed
		  
		  dim o as new Option("a", "", "")
		  
		  #pragma BreakOnExceptions false
		  try
		    o.AddAllowedValue("a", "b")
		    o.AddDisallowedValue("b", "c")
		    Assert.Fail("Values allowed and disallowed")
		  catch err as OptionParserException
		    Assert.Pass("Cannot allow and disallow values in the same option")
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AllowedValueTest()
		  dim o as new Option("a", "", "")
		  o.AddAllowedValue("a", "b")
		  
		  #pragma BreakOnExceptions false
		  try
		    o.HandleValue("a")
		    Assert.Pass("Allowed value allowed")
		  catch err as OptionParserException
		    Assert.Fail("Allowed value was not allowed")
		  end try
		  
		  try
		    o.HandleValue("z")
		    Assert.Fail("Value not on allowed list was allowed")
		  catch err as OptionParserException
		    Assert.Pass("Value not on allowed list not allowed")
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ArrayTest()
		  Dim o As New Option("a", "array", "Array of Integers", Option.OptionType.Integer)
		  o.IsArray = True
		  
		  o.HandleValue("1")
		  o.HandleValue("5")
		  o.HandleValue("1029")
		  
		  Dim v() As Variant = o.Value
		  Assert.AreEqual(1, v(0).IntegerValue)
		  Assert.AreEqual(5, v(1).IntegerValue)
		  Assert.AreEqual(1029, v(2).IntegerValue)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BasicOptionTest()
		  Dim o As Option
		  
		  o = New Option("a", "apple", "Display an apple", Option.OptionType.Boolean)
		  Assert.AreEqual("a", o.ShortKey)
		  Assert.AreEqual("apple", o.LongKey)
		  Assert.AreEqual("Display an apple", o.Description)
		  Assert.IsTrue(Option.OptionType.Boolean = o.Type, "default option type is Boolean")
		  Assert.AreEqual("BOOL", o.TypeString)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BooleanHandleValueTest()
		  Dim o As Option
		  
		  o = New Option("t", "test", "Unit Testing", Option.OptionType.Boolean)
		  o.HandleValue("Yes")
		  Assert.IsTrue(o.Value, "Yes")
		  
		  o.HandleValue("YES")
		  Assert.IsTrue(o.Value, "YES")
		  
		  o.HandleValue("y")
		  Assert.IsTrue(o.Value, "y")
		  
		  o.HandleValue("1")
		  Assert.IsTrue(o.Value, "1")
		  
		  o.HandleValue("on")
		  Assert.IsTrue(o.Value, "on")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DisallowedValueTest()
		  dim o as new Option("a", "", "")
		  o.AddDisallowedValue("a", "b")
		  
		  #pragma BreakOnExceptions false
		  try
		    o.HandleValue("a")
		    Assert.Fail("Disallowed value allowed")
		  catch err as OptionParserException
		    Assert.Pass("Disallowed value was not allowed")
		  end try
		  
		  try
		    o.HandleValue("z")
		    Assert.Pass("Value not on disallowed list was allowed")
		  catch err as OptionParserException
		    Assert.Fail("Value not on disallowed list not allowed")
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IntegerHandleValueTest()
		  Dim o As Option
		  
		  o = New Option("t", "test", "Unit Testing", Option.OptionType.Integer)
		  o.HandleValue("")
		  Assert.IsTrue(o.Value = 0)
		  
		  o.HandleValue("1")
		  Assert.IsTrue(o.Value = 1)
		  
		  o.HandleValue("10293")
		  Assert.IsTrue(o.Value = 10293)
		  
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
