import SwiftUI
import Entities

struct TransactionCell: View {
    private let transaction: TransactionState

    var body: some View {
        HStack {
            VStack {
                Text(transaction.formattedDate)
                Text(transaction.partnerDisplayName)
                HStack {
                    Text(transaction.description ?? "")
                }
            }
            
            Spacer()
            
            Text("\(transaction.value.formattedValue)")
        }
    }
    
    
    public init(transaction: TransactionState) {
        self.transaction = transaction
    }
}

#Preview(traits: .fixedLayout(width: 300, height: 150)) {
    TransactionCell(transaction: TransactionState(id: "123", partnerDisplayName: "Partner Name", category: 12, description: "Some Description", bookingDate: nil, value: TransactionValueState(value: 1234, currencyCode: "USD")))
}
