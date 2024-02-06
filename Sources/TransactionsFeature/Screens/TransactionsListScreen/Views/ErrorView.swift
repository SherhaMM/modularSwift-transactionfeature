import SwiftUI

struct ErrorView: View {
    private let error: Error
    var action: (() -> Void)?
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
            Text(Strings.errorLabel)
                .bold()
            Text(error.localizedDescription)
            Button(action: {
                action?()
            }, label: {
                Text("Try again")
            })
            .padding()
        }
        .padding()
    }
    
    public init(_ error: Error, action: (() -> Void)? = nil) {
        self.error = error
        self.action = action
    }
}

#if DEBUG

#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    VStack {
        ErrorView(ViewStateError.networkError)
        .padding()

        ErrorView(ViewStateError.unknownError("Some Error"))
        .padding()
    }
}

#endif
