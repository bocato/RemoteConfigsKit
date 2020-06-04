import Foundation
import RemoteConfigsKitInterface

struct RemoteConfigValue {
    let name: String
    let stringValue: String?
    let dataType: DynamicValueDataType
    let origin: Origin
    let description: String
    let provider: String
}

extension DynamicValueDataType {
    func parse(_ value: String) -> String {
        switch self {
        case .bool:
            return formatBoolString(value)
        default:
            return value
        }
    }

    private func formatBoolString(_ value: String) -> String {
        switch value.lowercased() {
        case "1", "yes", "true":
            return "true"
        default:
            return "false"
        }
    }
}

extension RemoteConfigValue {
    enum Origin {
        case provider(named: String)
        case storage(named: String)
        case defaultValue

        var name: String {
            switch self {
            case let .provider(providerName):
                return providerName
            case let .storage(storageName):
                return storageName
            case let .defaultValue:
                return "Default Value"
            }
        }
    }
}
