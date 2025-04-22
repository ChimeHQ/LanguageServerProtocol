<div align="center">

[![Build Status][build status badge]][build status]
[![Platforms][platforms badge]][platforms]
[![Documentation][documentation badge]][documentation]
[![Matrix][matrix badge]][matrix]

</div>

# LanguageServerProtocol

This is a Swift library for interacting with [Language Server Protocol](https://microsoft.github.io/language-server-protocol/). It contains type definitions and utilities useful for both server- and client-side projects.

Need to interact with servers? You may want to take a look at [LanguageClient](https://github.com/ChimeHQ/LanguageClient).
Want to build a server? Check out [LanguageServer](https://github.com/ChimeHQ/LanguageServer).

## Typing Approach

Where possible, this library matches the LSP spec. However, there are some additional types present in this library that aren't in the spec. This is caused by the use of anonymous structures.

This library models these cases using nested structures and/or the `TwoTypeOption` and `ThreeTypeOption` types.

## Integration

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/LanguageServerProtocol", from: "0.11.0")
]
```

## Extra Features

For the most part, this library strives to be a straightforward version of the spec in Swift. There are a few places, however, where it just makes sense to pull in some extra functionality.

- `Snippet`: makes it easier to interpret the contents of completion results
- `TokenRepresentation`: maintains the state of a document's semantic tokens
- `DataChannel.withMessageFraming`: wraps an existing JSONRPC DataChannel up with HTTP header-based message framing 

If you need to support other communication channels, you'll have to work with the `DataChannel` type from the [JSONRPC](https://github.com/ChimeHQ/JSONRPC) package. There are a few specialized ones already defined in [LanguageClient](https://github.com/ChimeHQ/LanguageClient).

## Client Support

Right now, there are still some bits useful for client support in this library:

- `MockServer`: a stand-in that is useful for mocking a real server
- `Server`: a protocol that describes the essential server functionality

The intention is to migrate all of these out into LanguageClient, leaving this library purely focused on protocol-level support.

## Usage

### Responding to Events

You can respond to server events using `eventSequence`. Be careful here as some servers require responses to certain requests. It is also potentially possible that not all request types have been mapped in the `ServerRequest` type. The spec is big! If you find a problem, please open an issue!

```swift
Task {
    for await event in server.eventSequence {
        print("receieved event:", event)
        
        switch event {
        case let .request(id: id, request: request):
            request.relyWithError(MyError.unsupported)
        default:
            print("dropping notification/error")
        }
    }
}
```


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
| textDocument/prepareTypeHierarchy | ✅ |
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
| typeHierarchy/subtypes | ✅ |
| typeHierarchy/supertypes | ✅ |
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

I would love to hear from you! Issues or pull requests work great. Both a [Matrix space][matrix] and [Discord][discord] are available for live help, but I have a strong bias towards answering in the form of documentation. You can also find me on [the web](https://www.massicotte.org).

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/ChimeHQ/LanguageServerProtocol/actions
[build status badge]: https://github.com/ChimeHQ/LanguageServerProtocol/workflows/CI/badge.svg
[platforms]: https://swiftpackageindex.com/ChimeHQ/LanguageServerProtocol
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FLanguageServerProtocol%2Fbadge%3Ftype%3Dplatforms
[documentation]: https://swiftpackageindex.com/ChimeHQ/LanguageServerProtocol/main/documentation
[documentation badge]: https://img.shields.io/badge/Documentation-DocC-blue
[matrix]: https://matrix.to/#/%23chimehq%3Amatrix.org
[matrix badge]: https://img.shields.io/matrix/chimehq%3Amatrix.org?label=Matrix
[discord]: https://discord.gg/esFpX6sErJ
