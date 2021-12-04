import Foundation
import SwiftLSPClient

public struct SemanticTokensRegistrationOptions: Codable {
    public var documentSelector: DocumentSelector?
    public var id: String?
    public var workDoneProgress: Bool?

    public var legend: SemanticTokensLegend
    public var range: SemanticTokensClientCapabilities.Requests.RangeOption
    public var full: SemanticTokensClientCapabilities.Requests.FullOption
}
