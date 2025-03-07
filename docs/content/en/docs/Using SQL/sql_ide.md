---
title: "Experimental IDE"
weight: 5
description: Get real-time feedback as you type sql
---

Moor ships with an experimental analyzer plugin that provides real-time feedback on errors,
hints, folding and outline.

## Features

At the moment, the IDE supports 

- auto-complete to suggest matching keywords as you type
- warnings and errors for your queries
- navigation (Ctrl click on a reference to see where a column or table is declared)
- an outline view highlighting tables and queries
- folding inside `CREATE TABLE` statements and import-blocks

We would very much like to support syntax highlighting, but sadly VS Code doesn't support
that. Please upvote [this issue](https://github.com/microsoft/vscode/issues/585) to help
us here.

## Setup
To use the plugin, you need a supported editor (see below).

First, tell the Dart analysis server to run the moor plugin. Create a file called
`analysis_options.yaml` in your project root, next to your pubspec. It should contain
this section:
```yaml
analyzer:
  plugins:
    - moor
```

Then, follow the steps for the IDE you want to use.

### Using with VS Code

Make sure that your project depends on moor 2.0 or later. Then

1. In the preferences, make sure that the `dart.analyzeAngularTemplates` option is
   set to true. Contrary to its name, that flag turns on the plugin system, so you
   don't need to worry about angular.
2. Tell Dart Code to analyze moor files as well. Add this to your `settings.json`:
   ```json
   "dart.additionalAnalyzerFileExtensions": [
        "moor"
    ]
    ```
3. Finally, close and reopen your IDE so that the analysis server is restarted. The analysis server will
   then load the moor plugin and start providing analysis results for `.moor` files. Loading the plugin
   can take some time (around a minute for the first time).

### Other IDEs

Unfortunately, we can't support IntelliJ and Android Studio yet. Please vote on
[this issue](https://youtrack.jetbrains.com/issue/WEB-41424) to help us here!

If you're looking for support for an other IDE that uses the Dart analysis server,
please create an issue. We can probably make that happen.