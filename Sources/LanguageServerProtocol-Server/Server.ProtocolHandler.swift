import Foundation
import JSONRPC
import LanguageServerProtocol
import Logging

public protocol ProtocolHandler {
  var connection: JSONRPCClientConnection { get }
}
