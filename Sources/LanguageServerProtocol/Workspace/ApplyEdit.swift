import Foundation

public struct ApplyWorkspaceEditParams: Codable, Hashable, Sendable {
	public var label: String?
	public var edit: WorkspaceEdit

	public init(label: String? = nil, edit: WorkspaceEdit) {
		self.label = label
		self.edit = edit
	}
}

public struct ApplyWorkspaceEditResult: Codable, Hashable, Sendable {
	public var applied: Bool
	public var failureReason: String?
	public var failedChange: UInt?

	public init(applied: Bool, failureReason: String? = nil, failedChange: UInt? = nil) {
		self.applied = applied
		self.failureReason = failureReason
		self.failedChange = failedChange
	}
}
