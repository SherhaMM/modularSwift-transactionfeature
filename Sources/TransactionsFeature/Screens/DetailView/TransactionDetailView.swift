import SwiftUI
import Entities

public struct TransactionDetailView: View {
    let transaction: TransactionState
    
    public var body: some View {
        VStack {
            Text(transaction.partnerDisplayName)
                .bold()
                .font(.largeTitle)
            Divider()
            List {
                Section(Strings.detailsDescription) {
                    Text(transaction.description ?? "Empty Description")
                }
            }
            Spacer()
        }
    }
}

#Preview {
    TransactionDetailView(transaction: TransactionState(id: "123", partnerDisplayName: "Partner Name", category: 1, description: "Description exists", bookingDate: Date(), value: TransactionValueState(value: 119, currencyCode: "USD")))
}
