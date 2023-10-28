import Foundation
import JSONRPC
import LanguageServerProtocol

public protocol ProtocolHandler {
  var connection: JSONRPCClientConnection { get }
}
