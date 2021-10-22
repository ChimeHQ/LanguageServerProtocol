import Foundation
import JSONRPC
import SwiftLSPClient

public extension JSONRPCResponse {
    func getServerResult() -> Result<T, ServerError> {
        switch (result, error) {
        case (nil, nil):
            return .failure(.missingExpectedResult)
        case (let value?, nil):
            return .success(value)
        case (_, let errorValue?):
            let serverError = ServerError.serverError(code: errorValue.code,
                                                      message: errorValue.message,
                                                      data: errorValue.data)

            return .failure(serverError)
        }
    }
}

public extension JSONRPCRequest {
    func getParams() -> Result<T, ServerError> {
        if let params = params {
            return .success(params)
        } else {
            return .failure(.missingExpectedParameter)
        }
    }
}
