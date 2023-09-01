import Foundation
import JSONRPC
import LanguageServerProtocol
import Logging

public protocol ProtocolHandler {
  var lsp: JSONRPCServer { get }
  var logger: Logger { get }
}

public extension ProtocolHandler {

  func logInternalError(_ message: String, type: MessageType = .warning) async {
    do {
      try await lsp.sendNotification(.windowLogMessage(LogMessageParams(type: type, message: message)))
    }
    catch {
      logger.error(Logger.Message(stringLiteral: message))
    }
  }

}
