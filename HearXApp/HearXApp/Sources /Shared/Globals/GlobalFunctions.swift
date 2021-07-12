import Foundation

func localizedString(forKey key: String) -> String {
    let value = NSLocalizedString(key, tableName: "AppStrings", value: "", comment: "")
    return value
}
