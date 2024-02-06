import Foundation

enum ViewState<T: Equatable> {
    case idle
    case loading
    case loaded(T)
    case failed(ViewStateError)
}

extension ViewState: Equatable {}

extension ViewState {
    mutating func setLoadingIfNeeded() {
        switch self {
        case .failed(_), .idle: self = .loading
        default: break
        }
    }
}

