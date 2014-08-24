Welcome
=======

`OptionParser` is a set of classes to handle parsing command line parameters given to
a [Xojo](http://www.xojo.com) application. `OptionParser` handles all three application
types:

1. Desktop
2. Console
3. Web

Downloading
-----------

To download the latest release of `OptionParser` visit the
[Releases](https://github.com/jcowgar/xojo-option-parser/releases) page on GitHub.

To download the latest bleeding edge development version, please fork/clone the
GitHub repository [xojo-option-parser](https://github.com/jcowgar/xojo-option-parser).

Getting Started
---------------

To get started, simply include the `.xojo_xml_code` files in your project, populate
the `OptionParser` with a few `Option`'s and call `.Parse(args)`:

```
Dim opt As New OptionParser
opt.AddOption New Option("v", "verbose", "Enable verbose output", Option.OptionType.Boolean)
opt.AddOption New Option("f", "file", "File to parse", Option.OptionType.File)
opt.Parse(args) // System.CommandLine for GUI/Web

If opt.BooleanValue("verbose") Then // could access as "v" as well
  Print "Verbosity is on!"
End If

Dim fh As FolderItem = opt.FileValue("file")
// Do work with fh
```

How to Help
-----------

When using `OptionParser` in your own applications, if you run into a bug:

1. At bare minimum, submit a bug report at
   [github/jcowgar/xojo-option-parser/issues](https://github.com/jcowgar/xojo-option-parser/issues).
2. Better yet, fork the repo, fix the bug and submit a pull request,
   [github/jcowgar/xojo-option-parser/fork](https://github.com/jcowgar/xojo-option-parser/fork).
3. Best, fork the repo, add a unit test exposing the bug, fix the bug,
   and then submit a pull request (see #2).
