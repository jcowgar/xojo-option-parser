Dim resultCode As Integer
Dim o As String = DoShellCommand("xojodoc -i OptionParser --output-format=markdown -o ""$PROJECT_PATH/../docs/docs"" ""$PROJECT_FILE""", ResultCode)

If resultCode <> 0 Then
Print "ERROR: " + Str(resultCode) + EndOfLine + EndOfLine + o
End If