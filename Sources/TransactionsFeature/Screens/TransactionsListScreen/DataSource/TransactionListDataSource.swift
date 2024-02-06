import Foundation
import Entities
import Combine

struct TransactionListDataSource {
    // MARK: Public Variables
    public var dataPublisher = PassthroughSubject<[TransactionState], Never>()
    public var filteringOptions: [Int] = []
    public var chosenFilter: Int? = nil
    
    // MARK: Private Variables
    private var allTransactions: [TransactionState] = []
    private var filteredTransactions: [TransactionState] = []
    private var shouldDisplayFilteredTransactions: Bool { chosenFilter != nil }
    
    private var data: [TransactionState] {
        shouldDisplayFilteredTransactions ? filteredTransactions : allTransactions
    }
    
    //MARK: Public methods
    public mutating func setData(transactions: [TransactionState]) {
        let preparedData = prepareData(transactions)
        filteringOptions = preparedData.uniqueSortedCategories()
        allTransactions = preparedData
        filteredTransactions = []
        
        if let chosenFilter, filteringOptions.contains(chosenFilter) {
            setFiltering(option: chosenFilter)
        } else {
            setFiltering(option: nil)
        }
    }
    
    public mutating func updateFiltering(option: Int?) {
        guard chosenFilter != option else { return }
        setFiltering(option: option)
    }
    
    //MARK: Private methods
    private mutating func setFiltering(option: Int?) {
        defer { dataPublisher.send(data) }
        chosenFilter = option
        filteredTransactions = allTransactions.filter { $0.category == option }
    }
    
    private func prepareData(_ data: [TransactionState]) -> [TransactionState] {
        data.sortedByDateDesc()
    }
}
