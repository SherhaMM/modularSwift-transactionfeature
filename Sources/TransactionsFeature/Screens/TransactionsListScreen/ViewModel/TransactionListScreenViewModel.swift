import Foundation
import SwiftUI
import Combine
import UseCaseProtocol
import Entities

@MainActor
final public class TransactionListScreenViewModel: ObservableObject {
    // MARK: Dependencies
    private let networkMonitor: NetworkMonitoring
    private let getTransactionsUseCase: GetTransactionsUseCaseProtocol
    
    // MARK: Variables
    @Published
    public var isFilteringDialogOpen = false
    @Published
    private(set) var state: ViewState<[TransactionState]> = .idle
    private(set) var dataSource = TransactionListDataSource()
    private var networkConnected = true
    private var bag = Set<AnyCancellable>()
    
    public init(
        getTransactionsUseCase: GetTransactionsUseCaseProtocol,
        networkMonitor: NetworkMonitoring
    ) {
        self.getTransactionsUseCase = getTransactionsUseCase
        self.networkMonitor = networkMonitor
        
        subscribeToDataUpdates()
        subscribeToNetworkUpdates()
    }
}

extension TransactionListScreenViewModel {
    func loadTransactions() async {
        guard state != .loading else { return }
        do {
            state.setLoadingIfNeeded()
            let transactions = try await getTransactionsUseCase.execute()
            dataSource.setData(transactions: transactions)
        } catch let error {
            let errorDescription = error.localizedDescription
            state = .failed(networkConnected ? .unknownError(errorDescription) : .networkError)
        }
    }
    
    func updateFiltering(to option: Int?) {
        dataSource.updateFiltering(option: option)
    }
    
    // MARK: Private Methods
    private func subscribeToDataUpdates() {
        dataSource.dataPublisher
            .sink { [weak self] transactions in
                self?.state = .loaded(transactions)
            }
            .store(in: &bag)
    }
    
    private func subscribeToNetworkUpdates() {
        networkMonitor.networkStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.networkConnected = status
            }
            .store(in: &bag)
    }
}
