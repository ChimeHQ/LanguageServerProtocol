[![Build Status][build status badge]][build status]
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

## Extra Features

For the most part, this library strives to be a straightforward version of the spec in Swift. There are a few places, however, where it just makes sense to pull in some extra functionality.

- `MockServer`: a stand-in that is useful for mocking a real server
- `Server`: a protocol that describes the essential server functionality
- `Snippet`: makes it easier to interpret the contents of completion results
- `TokenRepresentation`: maintains the state of a document's semantic tokens
- `AsyncMessageFramingSequence`: parsers an input AsyncSequence with LSP's HTTP header-based message framing (see also `MessageFraming`)
- `AsyncByteSequence`: transforms a sequence of Data into a sequence of bytes

## Supported Features

The LSP [specification](https://microsoft.github.io/language-server-protocol/specification) is large, and this library currently does not implement it all. The intention is to support the 3.x specification, but be as backwards-compatible as possible with pre-3.0 servers.

| Message | Supported |
| ----------|:---------:|
| $/cancelRequest | ✅ |
| $/logTrace | ✅ |
| $/progress | ✅ |
| $/setTrace | ✅ |
| callHierarchy/incomingCalls | ✅ |
| callHierarchy/outgoingCalls | ✅ |
| client/registerCapability | ✅ |
| client/unregisterCapability | ✅ |
| codeAction/resolve | ✅ |
| codeLens/resolve | ✅ |
| completionItem/resolve | ✅ |
| documentLink/resolve | ✅ |
| exit | ✅ |
| initialize | ✅ |
| initialized | ✅ |
| inlayHint/resolve | ✅ |
| notebookDocument/didChange | - |
| notebookDocument/didClose | - |
| notebookDocument/didOpen | - |
| notebookDocument/didSave | - |
| server-defined | ✅ |
| shutdown | ✅ |
| telemetry/event | ✅ |
| textDocument/codeAction | ✅ |
| textDocument/codeLens | ✅ |
| textDocument/colorPresentation | ✅ |
| textDocument/completion | ✅ |
| textDocument/declaration | ✅ |
| textDocument/definition | ✅ |
| textDocument/diagnostic | ✅ |
| textDocument/didChange | ✅ |
| textDocument/didClose | ✅ |
| textDocument/didOpen | ✅ |
| textDocument/didSave | ✅ |
| textDocument/documentColor | ✅ |
| textDocument/documentHighlight | ✅ |
| textDocument/documentLink | ✅ |
| textDocument/documentSymbol | ✅ |
| textDocument/foldingRange | ✅ |
| textDocument/formatting | ✅ |
| textDocument/hover | ✅ |
| textDocument/implementation | ✅ |
| textDocument/inlayHint | ✅ |
| textDocument/inlineValue | - |
| textDocument/linkedEditingRange | ✅ |
| textDocument/moniker | ✅ |
| textDocument/onTypeFormatting | ✅ |
| textDocument/prepareCallHierarchy | ✅ |
| textDocument/prepareRename | ✅ |
| textDocument/prepareTypeHierarchy | - |
| textDocument/publishDiagnostics | ✅ |
| textDocument/rangeFormatting | ✅ |
| textDocument/references | ✅  |
| textDocument/rename | ✅ |
| textDocument/selectionRange | ✅ |
| textDocument/semanticTokens/full | ✅ |
| textDocument/semanticTokens/full/delta | ✅ |
| textDocument/semanticTokens/range | ✅ |
| textDocument/signatureHelp | ✅ |
| textDocument/typeDefinition | ✅ |
| textDocument/willSave | ✅ |
| textDocument/willSaveWaitUntil | ✅ |
| typeHierarchy/subtypes | - |
| typeHierarchy/supertypes | - |
| window/logMessage | ✅ |
| window/showDocument | ✅ |
| window/showMessage | ✅ |
| window/showMessageRequest | ✅ |
| window/workDoneProgress/cancel | ✅ |
| window/workDoneProgress/create | ✅ |
| workspace/applyEdit | ✅ |
| workspace/codeLens/refresh | ✅ |
| workspace/configuration | ✅ |
| workspace/diagnostic | - |
| workspace/diagnostic/refresh | - |
| workspace/didChangeConfiguration | ✅ |
| workspace/didChangeWatchedFiles | ✅ |
| workspace/didChangeWorkspaceFolders | ✅ |
| workspace/didCreateFiles | ✅ |
| workspace/didDeleteFiles | ✅ |
| workspace/didRenameFiles | ✅ |
| workspace/executeCommand | ✅ |
| workspace/inlayHint/refresh | ✅ |
| workspace/inlineValue/refresh | - |
| workspace/semanticTokens/refresh | ✅ |
| workspace/symbol | ✅ |
| workspace/willCreateFiles | ✅ |
| workspace/willDeleteFiles | ✅ |
| workspace/willRenameFiles | ✅ |
| workspace/workspaceFolders | ✅ |
| workspaceSymbol/resolve | ✅ |

## Contributing and Collaboration

I'd love to hear from you! Get in touch via [mastodon](https://mastodon.social/@mattiem), an issue, or a pull request.

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/ChimeHQ/LanguageServerProtocol/actions
[build status badge]: https://github.com/ChimeHQ/LanguageServerProtocol/workflows/CI/badge.svg
[platforms]: https://swiftpackageindex.com/ChimeHQ/LanguageServerProtocol
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FLanguageServerProtocol%2Fbadge%3Ftype%3Dplatforms
