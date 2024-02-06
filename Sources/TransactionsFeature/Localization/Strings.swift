import Foundation

struct Strings {
    // Use codegen
    static let errorLabel = localized("list.lbl.error")
    static let checkConnection = localized("list.lbl.check_connection")
    static let transactions = localized("list.lbl.transactions")
    static let dialogTitle = localized("list.dialog.title")
    static let filteringButton = localized("list.lbl.filter_button")
    static let resetFilters = localized("list.lbl.reset_filters")
    static let loading = localized("list.lbl.loading")
    static let total = localized("list.total")
    static let detailsDescription = localized("details.description_section.title")
    
    private static func localized(_ str: String) -> String {
        NSLocalizedString(str, bundle: .module, comment: "")
    }
}
