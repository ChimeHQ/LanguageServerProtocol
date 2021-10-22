# LanguageServerProtocol

This is a Swift library for interacting with [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) implementations. It contains type definitions and utilities useful for both server- and client-side implemenations.

This project was derived from, and still depends on [SwiftLSPClient](https://github.com/ChimeHQ/SwiftLSPClient). That library mixes both the underlying protocol handling with a client-level abstraction. The ultimate goal of this project is to provide a complete set of types for working with LSP.

However, there's a lot in SwiftLSPClient, so a full migration is going to take a while. In the mean time, you should assume that SwiftLSPClient is soft-deprecated. New projects shouldn't use it. A soon-to-be released Swift library that focuses on a higher-level client implenenation is forthcoming.

## Supported Features

The LSP [specification](https://microsoft.github.io/language-server-protocol/specification) is large, and this library currently does not implement it all. The intention is to support the 3.x specification, but be as backwards-compatible as possible with pre-3.0 servers. 

| Feature            | Supported |
| -------------------|:---------:|
| window/showMessage | ✅ |
| window/showMessageRequest | ✅ |
| window/showDocument | - |
| window/logMessage | ✅ |
| window/workDoneProgress/create | - |
| window/workDoneProgress/cancel | - |
| $/cancelRequest | - |
| $/progress | - |
| initialize | ✅ |
| shutdown | ✅ |
| exit | ✅ |
| telemetry/event | - |
| $/logTrace | - |
| $/setTrace | - |
| client/registerCapability | ✅ |
| client/unregisterCapability | ✅ |
| workspace/workspaceFolders | - |
| workspace/didChangeWorkspaceFolders | - |
| workspace/didChangeConfiguration | - |
| workspace/configuration | ✅ |
| workspace/didChangeWatchedFiles | - |
| workspace/symbol | - |
| workspace/executeCommand | - |
| workspace/applyEdit | - |
| workspace/willCreateFiles | - |
| workspace/didCreateFiles | - |
| workspace/willRenameFiles | - |
| workspace/didRenameFiles | - |
| workspace/willDeleteFiles | - |
| workspace/didDeleteFiles | - |
| textDocument/didOpen | ✅ |
| textDocument/didChange | ✅ |
| textDocument/willSave | ✅ |
| textDocument/willSaveWaitUntil | ✅ |
| textDocument/didSave | ✅ |
| textDocument/didClose | ✅ |
| textDocument/publishDiagnostics | ✅ |
| textDocument/completion | ✅ |
| completionItem/resolve | - |
| textDocument/hover | ✅ |
| textDocument/signatureHelp | ✅ |
| textDocument/declaration | ✅ |
| textDocument/definition | ✅ |
| textDocument/typeDefinition | ✅ |
| textDocument/implementation | ✅ |
| textDocument/references | ✅  |
| textDocument/documentHighlight | - |
| textDocument/documentSymbol | ✅ |
| textDocument/codeAction | ✅ |
| codeLens/resolve | - |
| textDocument/codeLens | - |
| workspace/codeLens/refresh | - |
| textDocument/documentLink | - |
| documentLink/resolve | - |
| textDocument/documentColor | - |
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

## Integration

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/LanguageServerProtocol")
]
```

## Suggestions or Feedback

We'd love to hear from you! Get in touch via [twitter](https://twitter.com/chimehq), an issue, or a pull request.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
