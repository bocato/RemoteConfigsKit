import Foundation

// MARK: - Value Definition

public enum DynamicValueDataType: Equatable {
    case boolean
    case string
    case number
    case decodable
}

public protocol DynamicValue {
    associatedtype Data: Codable

    static var name: String { get }
    static var provider: RemoteConfigsDataProviderIdentifier { get }
    static var defaultValue: Data { get }
    static var description: String { get }
}

public extension DynamicValue {
    static var description: String { "" }
    static var stringValue: String? { String(describing: defaultValue) }
}

extension DynamicValue {
    private static func isNumeric<T>(_: T.Type) -> Bool {
        let isInt = T.self == Int.self
        let isDouble = T.self == Double.self
        let isFloat = T.self == Float.self
        return isDouble || isFloat || isInt
    }

    public static func extractType() -> DynamicValueDataType {
        if Data.self == Bool.self {
            return .boolean
        } else if isNumeric(Data.self) {
            return .number
        } else if Data.self == String.self {
            return .string
        } else {
            return .decodable
        }
    }
}
