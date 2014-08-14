
Checking an Xcode Project
----------------------------------------------------------------------

Faux Pas performs its checks on a single _Target_ of an _Xcode project_, using a single _Build Configuration_. At a minimum, the project must be specified — Faux Pas can select a default target and build configuration if they are left unspecified.

### Selecting Which Rules to Apply

Rules can be selected by their tags, or individually. Individual rules can also be excluded. Exclusions are applied last, so that if you exclude a rule that has a tag you have selected, the rule will not be applied.

- **GUI:**
    - Select rule tags by clicking their names in the rule selection view (rules that are selected via their tags will display a checkmark on their left side, in place of the individual selection checkbox control)
    - Select individual rules by checking the box next to them
    - Exclude individual rules by right-clicking (or command-clicking) on a rule in the list and selecting _Exclude Rule_
- **Command-Line:**
    - Use `-g` / `--ruleTags` to select all rules that have the specified tags
    - Use `-r` / `--rules` to select individual rules
    - Use `--excludedRules` to exclude individual rules

_**Recommendation:** Select rules by tags as much as possible, and avoid selecting individual rules if you can. Then exclude any rules you don’t want. This way new rules added in updated versions of this app will be selected automatically if they are tagged with tags you have selected._

In the command line, you can also use the `--onlyRules` argument to run only specific rules, overriding all the other rule selection options. This is handy when your project has a configuration file with rule tag selections and/or rule exclusions that you would like to temporarily override.


Using The Command-Line Interface
----------------------------------------------------------------------

In order to use Faux Pas from the command line, you must first **install the `fauxpas` command**:

- Open the Faux Pas GUI
- Select the _Faux Pas > Install CLI Tools…_ menu item from the application menu.

This will install the `fauxpas` command in `/usr/local/bin` but you can of course move it elsewhere if you wish.

To see the command-line interface documentation, run `fauxpas help` in the terminal.


Configuration
----------------------------------------------------------------------

Faux Pas can be configured via:

- Command-line arguments _(if using the command-line interface)_
- The GUI
- Configuration files

The configuration files may be written in JSON or Property List formats. Regardless of this choice, the structure of the file remains the same. To see a full example configuration file in the JSON format, run `fauxpas exampleConfig` in the terminal _(note that this requires the [CLI tools](#using-the-command-line-interface) to be installed)_.

When using the command-line interface, a configuration file may be selected using the `-c` / `--configFile` argument.

### Project-specific Configuration Files

A project-specific configuration file may be used by adding it into a folder named `FauxPasConfig` in the project root folder (the same folder where the `.xcodeproj` folder resides) with the file extension `.fauxpas.json` (or `.fauxpas.plist`). The file may also reside elsewhere, as long as the file extension is one of these two and the Xcode project contains a reference to it.

If there are multiple configuration files in the `FauxPasConfig` folder, the default is the one named `main.fauxpas.json` (or `.plist`).

Project-specific configuration files will be automatically picked up, for both CLI and GUI invocations of the application.



Suppressing Diagnostics
----------------------------------------------------------------------

If you don’t find any of the diagnostics emitted by a particular rule useful (or disagree with the basic premise of the rule,) simply [exclude that rule from being applied](#selecting-which-rules-to-apply).


### Suppressing Diagnostics in Code

If you want to keep a rule enabled, but suppress diagnostics in specific sections of your code, you can use the macros defined in the `FauxPasAnnotations.h` header for that.

To add that header to your project, do this:

1. Run the Faux Pas GUI
2. Open your project
3. Select the _Project > Add Annotations Header…_ menu item

Further instructions on how to use the macros are included in the header file itself.


### Suppressing Diagnostics in Specific Files or Folders

Each rule in Faux Pas has an option called “Regexes for ignored file paths”. This option can be used to suppress diagnostics from that rule in all file paths that match any of the specified regular expressions.


### Excluding Specific Files, Folders, or Xcode Groups from Checks

If you want to exclude files that match specific patterns from being checked by Faux Pas, you can use the following options:

- Regexes for files to exclude `[--fileExclusionRegexes]`
- Prefixes of files to exclude `[--fileExclusionPrefixes]`
- Xcode groups to exclude `[--fileExclusionXcodeGroups]`

Note that these options don't just suppress diagnostics from matching files: they entirely exclude them from being checked.


Convenient Ways to Launch Faux Pas
----------------------------------------------------------------------

### Quickly Opening the Active Xcode Project in the Faux Pas GUI

You can use the `open` command to open a specific Xcode project in the Faux Pas GUI. Combine this with a short AppleScript snippet to get the currently active project path from Xcode:

    open -a FauxPas "`osascript -e 'tell application \"Xcode\" to return path of active project document'`"

You can use a helper application (like _Spark_, _Keyboard Maestro_ or _FastScripts_) to assign a global hotkey for this.


### Performing Checks During Xcode Builds

Faux Pas can be executed in an Xcode build phase. This allows you to see the diagnostics it produces in the Xcode GUI, and easily jump to the relevant file positions. This method also allows Faux Pas to “break the build” by returning a nonzero exit status (the `--minErrorStatusSeverity` option can be used to control the conditions in which Faux Pas returns an error exit status).

1. Ensure that you have the Faux Pas [CLI tools](#using-the-command-line-interface) installed
2. Create [a new "Run Script" build phase][xcode-new-script] in Xcode for the desired target in your project
3. Add the following as the contents of the script:

        [[ ${FAUXPAS_SKIP} == 1 ]] && exit 0

        FAUXPAS_PATH="/usr/local/bin/fauxpas"
        if [[ -f "${FAUXPAS_PATH}" ]]; then
          "${FAUXPAS_PATH}" check-xcode
        else
          echo "warning: Faux Pas was not found at '${FAUXPAS_PATH}'"
        fi

With this script, Faux Pas will be run during the build _unless_ the `FAUXPAS_SKIP` build setting is given the value `1`.

[xcode-new-script]: http://developer.apple.com/library/ios/#recipes/xcode_help-project_editor/Articles/AddingaRunScriptBuildPhase.html


### Manually Invoking Faux Pas in Xcode

To manually run Faux Pas from within Xcode:

1. Ensure that you have the Faux Pas [CLI tools](#using-the-command-line-interface) installed
2. Create a new _Aggregate_ target into your project and call it “Faux Pas”
3. Create [a new "Run Script" build phase][xcode-new-script] in Xcode for the “Faux Pas” target and name the phase “Run Faux Pas”
4. Add the following as the contents of the script, substituting the actual name of your project for `PROJECT_NAME`:

        /usr/local/bin/fauxpas -o xcode check "PROJECT_NAME.xcodeproj"

You can now invoke Faux Pas by building the “Faux Pas” scheme.


Processing the Diagnostics with Custom Scripts
----------------------------------------------------------------------

If you want to write your own custom scripts to process the diagnostics emitted by Faux Pas, you must first make it produce machine-readable output.

### Emitting Machine-readable Output

The `--outputFormat` (or `-o`) argument in the CLI allows you to specify the format in which diagnostics are written into the standard output stream. The possible values for this are:

- `human` — Human-readable output _(default)_
- `json` — JSON output
- `plist` — Property list output (currently this outputs an XML property list)
- `xcode` — Line-based output, as understood by Xcode. This is used by default when you use the `check-xcode` command, to get Xcode to display the diagnostics as errors and warnings.

In the GUI, you can press the _Export Diagnostics…_ button in the diagnostics view to save the diagnostics into a file in any of the above formats.


### The Structure of the Machine-readable Output

For all of the machine-readable formats, the actual structure of the diagnostic objects is the same — only the serialization format varies (the only exception to this is the fact that property list fields may not have “null” values, so such fields are simply omitted there.)

The root object has the following fields:

- `fauxPasVersion` — The version of Faux Pas used to produce the output
- `timeStamp` — A unix timestamp for the time when the output was produced
- `projectPath` — The filesystem path to the `.xcodeproj` folder
- `projectName` — The name of the checked Xcode project
- `targetName` — The name of the checked target in the Xcode project
- `targetBundleVersion` — The `CFBundleVersion` value from the checked target’s `Info.plist`
- `buildConfigurationName` — The name of the Xcode build configuration used
- `projectIconBase64PNG` — The project icon (as displayed in the Faux Pas GUI) as a base64-encoded PNG (120 by 120 pixels)
- `versionControlSystemName` — The name of the version control system used by the project
- `versionControlRevision` — The current version control system revision identifier _(Currently only supported for Git)_
- `diagnostics` — An array of diagnostic objects

The diagnostic objects have the following fields:

- `ruleShortName` — The short name of the rule that emitted this diagnostic
- `ruleName` — The full name of the rule that emitted this diagnostic
- `ruleDescription` — The full description of the rule that emitted this diagnostic
- `ruleWarning` - For some rules, an human-readable warning related to the produced diagnostics.
- `info` — Human-readable information about the diagnostic
- `html` — A dictionary containing all of the above keys, with HTML-formatted values.
- `identifier` — An arbitrary value chosen by each rule, usually to specify a relevant piece of data that the diagnostic refers to (e.g. the _Missing Translation_ rule will specify here the string resource key that seems to be missing.)
- `file` — The full path to the file that this diagnostic refers to
- `context` — The name/signature of a “parent” code symbol of the section of code this diagnostic refers to (e.g. a function or method, or a class)
- `extent` — Position markers for the section of `file` this diagnostic refers to
    - `start` and `end`, both with the following structure:
        - `line` — The line number
        - `byteColumn` — The column of `line`, in bytes
        - `byteOffset` — The offset from the beginning of the file, in bytes
        - `utf16Column` — The column of `line`, in UTF-16 units
        - `utf16Offset` — The offset from the beginning of the file, in UTF-16 units
- `fileSnippet` — The contents of the section of `file` this diagnostic refers to
- `impact` — What the primary “impact” of the problem described by this diagnostic is considered to be (`functionality`, `maintainability` or `style`)
- `severity` — How “severe” this diagnostic is considered to be (an integer [0-10] inclusive, higher values indicate higher severity)
- `severityDescription` — A textual description of `severity`
- `confidence` — How confident we are that this diagnostic is not a false positive (an integer [0-10] inclusive, higher values indicate higher confidence)
- `confidenceDescription` — A textual description of `confidence`



### Processing the Machine-readable Output

You may of course process the diagnostics data in any way you deem fit, but here is one suggestion: use [`jq`][jq] with the JSON output format.

Here is an example that prints out a list of resource files that are potentially unused in the project:

    $ fauxpas --onlyRules UnusedResource -o json check MyProject.xcodeproj \
      | jq --raw-output '.diagnostics[] | .file'
    /Users/username/myproject/unused1.jpg
    /Users/username/myproject/unused2.xml

[jq]: http://stedolan.github.io/jq


Troubleshooting
----------------------------------------------------------------------

### Faux Pas gives me compiler errors that I don’t get when compiling my project from Xcode

Faux Pas uses a slightly different version of the Clang compiler than Xcode does (this is by necessity: although LLVM/Clang is open source, Apple has its own closed-source fork of it).

#### Comparing the Clang versions

Run the following to see the version of Clang your Xcode installation is using:

    xcrun clang -dM -E -x c /dev/null | grep __VERSION__

And the following to see the version of Clang your Faux Pas installation is using:

    fauxpas -v version | grep Clang

Note, however, that Apple uses its own version number scheme for its Clang fork, which makes comparisons difficult. The following resource can help with this: <https://gist.github.com/yamaya/2924292>.


#### Suppressing compiler warnings

If you are using the `-Weverything` warning flag in your project, try removing it (this flag enables _all_ warnings in Clang, even the new, buggy/experimental ones). If you don’t want to disable this flag in your project configuration, but do want to disable it for Faux Pas, you can add `-Wno-everything` to the value of the “Additional compiler arguments to use” (`--extraCompilerArgs`) configuration option.

If you just want to disable all compiler warnings for Faux Pas (but not your project), add the flag `-w` to the “Additional compiler arguments to use” (`--extraCompilerArgs`) configuration option.


### Faux Pas fails to check my project

Please ensure that Faux Pas is using the correct `xcodebuild` arguments for your project. If you enable the `--verbose` option, Faux Pas will print the `xcodebuild` arguments it uses into the log output.

In order to determine what `xcodebuild` arguments are needed to correctly build your project, you can `cd` to the folder that contains your `.xcodeproj` in Terminal.app, and try running `xcodebuild` there (to begin with, using the same arguments as Faux Pas.)

#### Projects that generate source code

If your project __generates or modifies source files__ (e.g. headers) during a build, you must enable the “Build project before checking” (`--fullBuild`) option. The same applies if correctly interpreting your project’s source code depends on something else that is generate during the build (for example, a dependent project).

#### Projects built using a workspace

If your project is normally built using an Xcode Workspace, and __cannot be built as an independent project__, you must specify the `--workspace` and `--scheme` options.

When you open a project that does not have an associated configuration file in the GUI, a configuration help sheet will be shown that lets you easily select the workspace and scheme to use.


### I Have multiple versions of Xcode installed; how do I ensure Faux Pas uses the one I want it to use?

Faux Pas uses `xcrun` to find all the Xcode developer tools that it needs (e.g. `xcodebuild`). If you enable the `--verbose` option, Faux Pas will print these paths into the log when you check a project.

You can use the `xcode-select` program to change which Xcode your system uses.

    xcode-select -switch /Applications/Xcode.app

If you don’t want to make this change globally, you can set the `DEVELOPER_DIR` environment variable before executing Faux Pas.

    DEVELOPER_DIR="/Applications/Xcode.app" fauxpas <arguments...>

