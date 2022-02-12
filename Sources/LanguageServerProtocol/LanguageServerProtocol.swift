import JSONRPC
import SwiftLSPClient

typealias UnusedResult = String?
typealias UnusedParam = String?

public enum ClientNotification {
    public enum Method: String {
        case initialized
        case exit
        case workspaceDidChangeWatchedFiles = "workspace/didChangeWatchedFiles"
        case workspaceDidChangeConfiguration = "workspace/didChangeConfiguration"
        case workspaceDidChangeWorkspaceFolders = "workspace/didChangeWorkspaceFolders"
        case textDocumentDidOpen = "textDocument/didOpen"
        case textDocumentDidChange = "textDocument/didChange"
        case textDocumentDidClose = "textDocument/didClose"
        case textDocumentWillSave = "textDocument/willSave"
        case textDocumentDidSave = "textDocument/didSave"
        case protocolCancelRequest = "$/cancelRequest"
        case protocolSetTrace = "$/setTrace"
    }

    case initialized(InitializedParams)
    case exit
    case textDocumentDidChange(DidChangeTextDocumentParams)
    case didOpenTextDocument(DidOpenTextDocumentParams)
    case didChangeTextDocument(DidChangeTextDocumentParams)
    case didCloseTextDocument(DidCloseTextDocumentParams)
    case willSaveTextDocument(WillSaveTextDocumentParams)
    case didSaveTextDocument(DidSaveTextDocumentParams)
    case didChangeWatchedFiles(DidChangeWatchedFilesParams)
    case protocolCancelRequest(CancelParams)
    case protocolSetTrace(SetTraceParams)
    case workspaceDidChangeWorkspaceFolders(DidChangeWorkspaceFoldersParams)

    public var method: Method {
        switch self {
        case .initialized:
            return .initialized
        case .exit:
            return .exit
        case .textDocumentDidChange:
            return .textDocumentDidChange
        case .didOpenTextDocument:
            return .textDocumentDidOpen
        case .didCloseTextDocument:
            return .textDocumentDidClose
        case .willSaveTextDocument:
            return .textDocumentWillSave
        case .didChangeTextDocument:
            return .textDocumentDidChange
        case .didSaveTextDocument:
            return .textDocumentDidSave
        case .didChangeWatchedFiles:
            return .workspaceDidChangeWatchedFiles
        case .protocolCancelRequest:
            return .protocolCancelRequest
        case .protocolSetTrace:
            return .protocolSetTrace
        case .workspaceDidChangeWorkspaceFolders:
            return .workspaceDidChangeWorkspaceFolders
        }
    }
}

public enum ClientRequest {
    public enum Method: String {
        case initialize
        case shutdown
        case textDocumentWillSaveWaitUntil = "textDocument/willSaveWaitUntil"
        case textDocumentCompletion = "textDocument/completion"
        case textDocumentHover = "textDocument/hover"
        case textDocumentSignatureHelp = "textDocument/signatureHelp"
        case textDocumentDeclaration = "textDocument/declaration"
        case textDocumentDefinition = "textDocument/definition"
        case textDocumentTypeDefinition = "textDocument/typeDefinition"
        case textDocumentImplementation = "textDocument/implementation"
        case textDocumentReferences = "textDocument/references"
        case textDocumentDocumentHighlight = "textDocument/documentHighlight"
        case textDocumentDocumentSymbol = "textDocument/documentSymbol"
        case textDocumentCodeAction = "textDocument/codeAction"
        case textDocumentCodeLens = "textDocument/codeLens"
        case textDocumentDocumentLink = "textDocument/documentLink"
        case textDocumentDocumentColor = "textDocument/documentColor"
        case textDocumentFormatting = "textDocument/formatting"
        case textDocumentRangeFormatting = "textDocument/rangeFormatting"
        case textDocumentOnTypeFormatting = "textDocument/onTypeFormatting"
        case textDocumentRename = "textDocument/rename"
        case textDocumentPrepareRename = "textDocument/prepareRename"
        case textDocumentFoldingRange = "textDocument/foldingRange"
        case textDocumentSelectionRange = "textDocument/selectionRange"
        case textDocumentLinkedEditingRange = "textDocument/linkedEditingRange"
        case textDocumentSemanticTokens = "textDocument/semanticTokens"
        case textDocumentSemanticTokensRange = "textDocument/semanticTokens/range"
        case textDocumentSemanticTokensFull = "textDocument/semanticTokens/full"
        case textDocumentSemanticTokensFullDelta = "textDocument/semanticTokens/full/delta"
        case textDocumentMoniker = "textDocument/moniker"
    }

    case initialize(InitializeParams)
    case shutdown
    case willSaveWaitUntilTextDocument(WillSaveTextDocumentParams)
    case completion(CompletionParams)
    case hover(TextDocumentPositionParams)
    case signatureHelp(TextDocumentPositionParams)
    case declaration(TextDocumentPositionParams)
    case definition(TextDocumentPositionParams)
    case typeDefinition(TextDocumentPositionParams)
    case implementation(TextDocumentPositionParams)
    case documentSymbol(DocumentSymbolParams)
    case codeAction(CodeActionParams)
    case prepareRename(PrepareRenameParams)
    case rename(RenameParams)
    case formatting(DocumentFormattingParams)
    case rangeFormatting(DocumentRangeFormattingParams)
    case onTypeFormatting(DocumentOnTypeFormattingParams)
    case references(ReferenceParams)
    case foldingRange(FoldingRangeParams)
    case semanticTokensFull(SemanticTokensParams)
    case semanticTokensFullDelta(SemanticTokensDeltaParams)
    case semanticTokensRange(SemanticTokensRangeParams)

    public var method: Method {
        switch self {
        case .initialize:
            return .initialize
        case .shutdown:
            return .shutdown
        case .willSaveWaitUntilTextDocument:
            return .textDocumentWillSaveWaitUntil
        case .completion:
            return .textDocumentCompletion
        case .hover:
            return .textDocumentHover
        case .signatureHelp:
            return .textDocumentSignatureHelp
        case .declaration:
            return .textDocumentDeclaration
        case .definition:
            return .textDocumentDefinition
        case .typeDefinition:
            return .textDocumentTypeDefinition
        case .implementation:
            return .textDocumentImplementation
        case .documentSymbol:
            return .textDocumentDocumentSymbol
        case .codeAction:
            return .textDocumentCodeAction
        case .prepareRename:
            return .textDocumentPrepareRename
        case .rename:
            return .textDocumentRename
        case .formatting:
            return .textDocumentFormatting
        case .rangeFormatting:
            return .textDocumentRangeFormatting
        case .onTypeFormatting:
            return .textDocumentOnTypeFormatting
        case .references:
            return .textDocumentReferences
        case .foldingRange:
            return .textDocumentFoldingRange
        case .semanticTokensFull:
            return .textDocumentSemanticTokensFull
        case .semanticTokensFullDelta:
            return .textDocumentSemanticTokensFullDelta
        case .semanticTokensRange:
            return .textDocumentSemanticTokensRange
        }
    }
}

public enum ServerNotification {
    public enum Method: String {
        case windowLogMessage = "window/logMessage"
        case windowShowMessage = "window/showMessage"
        case textDocumentPublishDiagnostics = "textDocument/publishDiagnostics"
        case telemetryEvent = "telemetry/event"
        case protocolCancelRequest = "$/cancelRequest"
        case protocolProgress = "$/progress"
        case protocolLogTrace = "$/logTrace"
    }

    case windowLogMessage(LogMessageParams)
    case windowShowMessage(ShowMessageParams)
    case textDocumentPublishDiagnostics(PublishDiagnosticsParams)
    case telemetryEvent(LSPAny)
    case protocolCancelRequest(CancelParams)
    case protocolProgress(ProgressParams)
    case protocolLogTrace(LogTraceParams)

    public var method: Method {
        switch self {
        case .windowLogMessage:
            return .windowLogMessage
        case .windowShowMessage:
            return .windowShowMessage
        case .textDocumentPublishDiagnostics:
            return .textDocumentPublishDiagnostics
        case .telemetryEvent:
            return .telemetryEvent
        case .protocolCancelRequest:
            return .protocolCancelRequest
        case .protocolProgress:
            return .protocolProgress
        case .protocolLogTrace:
            return .protocolLogTrace
        }
    }
}

public enum ServerRequest {
    public enum Method: String {
        case workspaceConfiguration = "workspace/configuration"
        case workspaceFolders = "workspace/workspaceFolders"
        case clientRegisterCapability = "client/registerCapability"
        case clientUnregisterCapability = "client/unregisterCapability"
        case workspaceSemanticTokenRefresh = "workspace/semanticTokens/refresh"
        case windowShowMessageRequest = "window/showMessageRequest"
        case windowShowDocument = "window/showDocument"
        case windowWorkDoneProgressCreate = "window/workDoneProgress/create"
        case windowWorkDoneProgressCancel = "window/workDoneProgress/cancel"
    }

    case workspaceConfiguration(ConfigurationParams)
    case workspaceFolders
    case clientRegisterCapability(RegistrationParams)
    case clientUnregisterCapability(UnregistrationParams)
    case workspaceSemanticTokenRefresh
    case windowShowMessageRequest(ShowMessageRequestParams)
    case windowShowDocument(ShowDocumentParams)
    case windowWorkDoneProgressCreate(WorkDoneProgressCreateParams)
    case windowWorkDoneProgressCancel(WorkDoneProgressCancelParams)

    public var method: Method {
        switch self {
        case .workspaceConfiguration:
            return .workspaceConfiguration
        case .workspaceFolders:
            return .workspaceFolders
        case .clientRegisterCapability:
            return .clientRegisterCapability
        case .clientUnregisterCapability:
            return .clientUnregisterCapability
        case .workspaceSemanticTokenRefresh:
            return .workspaceSemanticTokenRefresh
        case .windowShowMessageRequest:
            return .windowShowMessageRequest
        case .windowShowDocument:
            return .windowShowDocument
        case .windowWorkDoneProgressCreate:
            return .windowWorkDoneProgressCreate
        case .windowWorkDoneProgressCancel:
            return .windowWorkDoneProgressCancel
        }
    }
}

public enum ServerRegistration {
    public enum Method: String {
        case workspaceDidChangeWatchedFiles = "workspace/didChangeWatchedFiles"
        case workspaceDidChangeConfiguration = "workspace/didChangeConfiguration"
        case workspaceDidChangeWorkspaceFolders = "workspace/didChangeWorkspaceFolders"

        case textDocumentSemanticTokens = "textDocument/semanticTokens"
    }

    case workspaceDidChangeWatchedFiles(DidChangeWatchedFilesRegistrationOptions)
    case textDocumentSemanticTokens(SemanticTokensRegistrationOptions)
    case workspaceDidChangeConfiguration
    case workspaceDidChangeWorkspaceFolders

    public var method: Method {
        switch self {
        case .workspaceDidChangeWatchedFiles:
            return .workspaceDidChangeWatchedFiles
        case .textDocumentSemanticTokens:
            return .textDocumentSemanticTokens
        case .workspaceDidChangeConfiguration:
            return .workspaceDidChangeConfiguration
        case .workspaceDidChangeWorkspaceFolders:
            return .workspaceDidChangeWorkspaceFolders
        }
    }
}
