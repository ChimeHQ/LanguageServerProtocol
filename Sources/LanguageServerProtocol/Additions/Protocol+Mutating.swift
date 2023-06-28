import Foundation

extension ClientNotification {
	public var mutatesServerState: Bool {
		return true
	}
}

extension ClientRequest {
	public var mutatesServerState: Bool {
		switch self {
		case .initialize:
			return true
		case .shutdown:
			return true
		case .workspaceWillCreateFiles:
			return true
		case .workspaceWillRenameFiles:
			return true
		case .workspaceWillDeleteFiles:
			return true
		case .willSaveWaitUntilTextDocument:
			return true
		case .custom:
			return true
		default:
			return false
		}
	}
}
