import SwiftUI
import Combine
import Entities

public struct TransactionListView: View {
    @ObservedObject var viewModel: TransactionListScreenViewModel
    
    public init(viewModel: TransactionListScreenViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            switch viewModel.state {
            case .idle: Text("")
            case .loading: LoadingView()
            case .loaded(let transactions):
                loadedView(transactions)
            case .failed(let error):
                ErrorView(error) {
                    Task {
                        await viewModel.loadTransactions()
                    }
                }
            }
        }
        .task {
            await viewModel.loadTransactions()
        }
    }
    
    @ViewBuilder
    private func loadedView(_ transactions: [TransactionState]) -> some View {
        Text(Strings.transactions)
            .font(.largeTitle)
        
        List(transactions, id: \.id) { transaction in
            // ZStack with an empty button fixes
            // SwiftUI bug when row stays selected
            // after navigating back from detail view
            ZStack {
                Button("") {}
                NavigationLink(value: transaction) {
                    TransactionCell(transaction: transaction)
                }
            }
        }
        .navigationDestination(for: TransactionState.self) { transaction in
            TransactionDetailView(transaction: transaction)
        }
        
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        viewModel.isFilteringDialogOpen.toggle()
                    }, label: {
                        Text(Strings.filteringButton)
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text(Strings.total + transactions.formattedTotalSumValue())
                }
            })
            .confirmationDialog(Strings.dialogTitle, isPresented: $viewModel.isFilteringDialogOpen, titleVisibility: .visible) {
                confirmationDialogContents()
            }
    }
    
    @ViewBuilder
    private func confirmationDialogContents() -> some View {
        ForEach(viewModel.dataSource.filteringOptions, id: \.self) { option in
            Button {
                withAnimation(.interactiveSpring) {
                    viewModel.updateFiltering(to: option)
                }
            } label: {
                Text("\(option)")
                Spacer()
            }
        }
        
        Button {
            withAnimation(.interactiveSpring) {
                viewModel.updateFiltering(to: nil)
            }
        } label: {
            Text(Strings.resetFilters)
        }
    }
}

#if DEBUG
// Create PreviewHelpers to simplify preview building
// possibly using mocked services
import UseCase
import Repositories
import DataProviders
import UseCaseProtocol
#Preview {
    NavigationStack {
        TransactionListView(viewModel: TransactionListScreenViewModel(
            getTransactionsUseCase:
                GetTransactionsUseCase(repository: TransactionRepository(
                    transactionProvider: FileTransactionsProvider())), networkMonitor: NetworkMonitor()
        )
        )
    }
}
#endif
