public protocol ErrorHandler {
	func internalError(_ error: Error) async
}
