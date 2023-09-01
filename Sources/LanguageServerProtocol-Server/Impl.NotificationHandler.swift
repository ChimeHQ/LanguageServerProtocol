import Foundation
import JSONRPC
import LanguageServerProtocol
import Logging

public protocol NotificationHandler : ProtocolHandler {

  func initialized(_ params: InitializedParams) async
  func exit() async
  func textDocumentDidOpen(_ params: DidOpenTextDocumentParams) async
  func textDocumentDidChange(_ params: DidChangeTextDocumentParams) async
  func textDocumentDidClose(_ params: DidCloseTextDocumentParams) async
  func textDocumentWillSave(_ params: WillSaveTextDocumentParams) async
  func textDocumentDidSave(_ params: DidSaveTextDocumentParams) async
  func protocolCancelRequest(_ params: CancelParams) async
  func protocolSetTrace(_ params: SetTraceParams) async
  func workspaceDidChangeWatchedFiles(_ params: DidChangeWatchedFilesParams) async
  func windowWorkDoneProgressCancel(_ params: WorkDoneProgressCancelParams) async
  func workspaceDidChangeWorkspaceFolders(_ params: DidChangeWorkspaceFoldersParams) async
  func workspaceDidChangeConfiguration(_ params: DidChangeConfigurationParams) async
  func workspaceDidCreateFiles(_ params: CreateFilesParams) async
  func workspaceDidRenameFiles(_ params: RenameFilesParams) async
  func workspaceDidDeleteFiles(_ params: DeleteFilesParams) async
}

public extension NotificationHandler {
  func handleNotification(_ notification: ClientNotification) async {
    logger.debug("notification: \(notification.method)")

    switch notification {
    case let .initialized(params):
      await initialized(params)
    case .exit:
      await exit()
    case let .textDocumentDidOpen(params):
      await textDocumentDidOpen(params)
    case let .textDocumentDidChange(params):
      await textDocumentDidChange(params)
    case let .textDocumentDidClose(params):
      await textDocumentDidClose(params)
    case let .textDocumentWillSave(params):
      await textDocumentWillSave(params)
    case let .textDocumentDidSave(params):
      await textDocumentDidSave(params)
    case let .protocolCancelRequest(params):
      await protocolCancelRequest(params)
    case let .protocolSetTrace(params):
      await protocolSetTrace(params)
    case let .workspaceDidChangeWatchedFiles(params):
      await workspaceDidChangeWatchedFiles(params)
    case let .windowWorkDoneProgressCancel(params):
      await windowWorkDoneProgressCancel(params)
    case let .workspaceDidChangeWorkspaceFolders(params):
      await workspaceDidChangeWorkspaceFolders(params)
    case let .workspaceDidChangeConfiguration(params):
      await workspaceDidChangeConfiguration(params)
    case let .workspaceDidCreateFiles(params):
      await workspaceDidCreateFiles(params)
    case let .workspaceDidRenameFiles(params):
      await workspaceDidRenameFiles(params)
    case let .workspaceDidDeleteFiles(params):
      await workspaceDidDeleteFiles(params)
    }
  }
}

/// Provide default implementations for all protocol methods
/// We do this since the handler only need to support a subset, based on dynamically registered capabilities
public extension NotificationHandler {
  private func _logNotImplemented(_ message: String) async {
    do {
      try await lsp.sendNotification(.windowLogMessage(LogMessageParams(type: .warning, message: message)))
    }
    catch {
      logger.debug(Logger.Message(stringLiteral: message))
    }
  }

  func initialized(_ params: InitializedParams) async {
    await _logNotImplemented("NotificationHandler.initialized not implemented")
  }

  func exit() async {
    await _logNotImplemented("NotificationHandler.exit not implemented")
  }

  func textDocumentDidOpen(_ params: DidOpenTextDocumentParams) async {
    await _logNotImplemented("NotificationHandler.textDocumentDidOpen not implemented")
  }

  func textDocumentDidChange(_ params: DidChangeTextDocumentParams) async {
    await _logNotImplemented("NotificationHandler.textDocumentDidChange not implemented")
  }

  func textDocumentDidClose(_ params: DidCloseTextDocumentParams) async {
    await _logNotImplemented("NotificationHandler.textDocumentDidClose not implemented")
  }

  func textDocumentWillSave(_ params: WillSaveTextDocumentParams) async {
    await _logNotImplemented("NotificationHandler.textDocumentWillSave not implemented")
  }

  func textDocumentDidSave(_ params: DidSaveTextDocumentParams) async {
    await _logNotImplemented("NotificationHandler.textDocumentDidSave not implemented")
  }

  func protocolCancelRequest(_ params: CancelParams) async {
    await _logNotImplemented("NotificationHandler.protocolCancelRequest not implemented")
  }

  func protocolSetTrace(_ params: SetTraceParams) async {
    await _logNotImplemented("NotificationHandler.protocolSetTrace not implemented")
  }

  func workspaceDidChangeWatchedFiles(_ params: DidChangeWatchedFilesParams) async {
    await _logNotImplemented("NotificationHandler.workspaceDidChangeWatchedFiles not implemented")
  }

  func windowWorkDoneProgressCancel(_ params: WorkDoneProgressCancelParams) async {
    await _logNotImplemented("NotificationHandler.windowWorkDoneProgressCancel not implemented")
  }

  func workspaceDidChangeWorkspaceFolders(_ params: DidChangeWorkspaceFoldersParams) async {
    await _logNotImplemented("NotificationHandler.workspaceDidChangeWorkspaceFolders not implemented")
  }

  func workspaceDidChangeConfiguration(_ params: DidChangeConfigurationParams) async {
    await _logNotImplemented("NotificationHandler.workspaceDidChangeConfiguration not implemented")
  }

  func workspaceDidCreateFiles(_ params: CreateFilesParams) async {
    await _logNotImplemented("NotificationHandler.workspaceDidCreateFiles not implemented")
  }

  func workspaceDidRenameFiles(_ params: RenameFilesParams) async {
    await _logNotImplemented("NotificationHandler.workspaceDidRenameFiles not implemented")
  }

  func workspaceDidDeleteFiles(_ params: DeleteFilesParams) async {
    await _logNotImplemented("NotificationHandler.workspaceDidDeleteFiles not implemented")
  }

}
