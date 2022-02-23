[![Build Status][build status badge]][build status]
[![License][license badge]][license]
[![Platforms][platforms badge]][platforms]

# LanguageServerProtocol

This is a Swift library for interacting with [Language Server Protocol](https://microsoft.github.io/language-server-protocol/). It contains type definitions and utilities useful for both server- and client-side projects.

This project was derived from [SwiftLSPClient](https://github.com/ChimeHQ/SwiftLSPClient). That library mixes both the underlying protocol handling with a client-level abstraction. It is no longer officially supported.

If you are looking for a way to interact with servers, you probably want to use the higher-level [LanguageClient](https://github.com/ChimeHQ/LanguageClient).

## Typing Approach

Where possible, this library matches the LSP spec. However, there are some additional types present in this library that aren't in the spec. This is caused by the use of anonymous structures.

This library models these cases using nested structures and/or the `TwoTypeOption` and `ThreeTypeOption` types.

## Integration

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/LanguageServerProtocol")
]
```

## Supported Features

The LSP [specification](https://microsoft.github.io/language-server-protocol/specification) is large, and this library currently does not implement it all. The intention is to support the 3.x specification, but be as backwards-compatible as possible with pre-3.0 servers. 

| Feature            | Supported |
| -------------------|:---------:|
| window/showMessage | ✅ |
| window/showMessageRequest | ✅ |
| window/showDocument | ✅ |
| window/logMessage | ✅ |
| window/workDoneProgress/create | ✅ |
| window/workDoneProgress/cancel | ✅ |
| $/cancelRequest | ✅ |
| $/progress | ✅ |
| initialize | ✅ |
| shutdown | ✅ |
| exit | ✅ |
| telemetry/event | ✅ |
| $/logTrace | ✅ |
| $/setTrace | ✅ |
| client/registerCapability | ✅ |
| client/unregisterCapability | ✅ |
| workspace/workspaceFolders | ✅ |
| workspace/didChangeWorkspaceFolders | ✅ |
| workspace/didChangeConfiguration | ✅ |
| workspace/configuration | ✅ |
| workspace/didChangeWatchedFiles | ✅ |
| workspace/symbol | ✅ |
| workspace/executeCommand | ✅ |
| workspace/applyEdit | ✅ |
| workspace/willCreateFiles | ✅ |
| workspace/didCreateFiles | ✅ |
| workspace/willRenameFiles | ✅ |
| workspace/didRenameFiles | ✅ |
| workspace/willDeleteFiles | ✅ |
| workspace/didDeleteFiles | ✅ |
| textDocument/didOpen | ✅ |
| textDocument/didChange | ✅ |
| textDocument/willSave | ✅ |
| textDocument/willSaveWaitUntil | ✅ |
| textDocument/didSave | ✅ |
| textDocument/didClose | ✅ |
| textDocument/publishDiagnostics | ✅ |
| textDocument/completion | ✅ |
| completionItem/resolve | ✅ |
| textDocument/hover | ✅ |
| textDocument/signatureHelp | ✅ |
| textDocument/declaration | ✅ |
| textDocument/definition | ✅ |
| textDocument/typeDefinition | ✅ |
| textDocument/implementation | ✅ |
| textDocument/references | ✅  |
| textDocument/documentHighlight | ✅ |
| textDocument/documentSymbol | ✅ |
| textDocument/codeAction | ✅ |
| codeLens/resolve | ✅ |
| textDocument/codeLens | ✅ |
| workspace/codeLens/refresh | ✅ |
| textDocument/documentLink | ✅ |
| documentLink/resolve | ✅ |
| textDocument/documentColor | ✅ |
| textDocument/colorPresentation | - |
| textDocument/formatting | ✅ |
| textDocument/rangeFormatting | ✅ |
| textDocument/onTypeFormatting | ✅ |
| textDocument/rename | ✅ |
| textDocument/prepareRename | ✅ |
| textDocument/foldingRange | ✅ |
| textDocument/selectionRange | - |
| textDocument/prepareCallHierarchy | - |
| textDocument/prepareCallHierarchy | - |
| callHierarchy/incomingCalls | - |
| callHierarchy/outgoingCalls | - |
| textDocument/semanticTokens/full | ✅ |
| textDocument/semanticTokens/full/delta | ✅ |
| textDocument/semanticTokens/range | ✅ |
| workspace/semanticTokens/refresh | ✅ |
| textDocument/linkedEditingRange | - |
| textDocument/moniker | - |

## Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

[build status]: https://github.com/ChimeHQ/LanguageServerProtocol/actions
[build status badge]: https://github.com/ChimeHQ/LanguageServerProtocol/workflows/CI/badge.svg
[license]: https://opensource.org/licenses/BSD-3-Clause
[license badge]: https://img.shields.io/github/license/ChimeHQ/LanguageServerProtocol
[platforms]: https://swiftpackageindex.com/ChimeHQ/LanguageServerProtocol
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FLanguageServerProtocol%2Fbadge%3Ftype%3Dplatforms
