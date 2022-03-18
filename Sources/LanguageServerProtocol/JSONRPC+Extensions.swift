import Foundation
import JSONRPC

public extension JSONRPCResponse {
    func getServerResult() -> Result<T, ServerError> {
        switch self {
        case .failure(_, let error):
            return .failure(.responseError(error))
        case .result(_, let value):
            return .success(value)
        }
    }
}

public extension JSONRPCRequest {
    func getParamsResult() -> Result<T, ServerError> {
        if let params = params {
            return .success(params)
        } else {
            return .failure(.missingExpectedParameter)
        }
    }
}

public extension AnyJSONRPCRequest {
    func response(with error: Error) -> AnyJSONRPCResponse {
        let error = AnyJSONRPCResponseError(code: JSONRPCErrors.internalError,
                                            message: error.localizedDescription)
        return AnyJSONRPCResponse.failure(id, error)
    }
}
