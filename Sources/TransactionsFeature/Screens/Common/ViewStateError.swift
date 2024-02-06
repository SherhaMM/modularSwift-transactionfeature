import Foundation

enum ViewStateError: Error, Equatable {
    case networkError
    case unknownError(String)
}

extension ViewStateError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError: Strings.checkConnection
        case .unknownError(let description): description
        }
    }
}
