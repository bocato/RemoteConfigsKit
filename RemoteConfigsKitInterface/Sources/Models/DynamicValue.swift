import Foundation

// MARK: - Value Definition

public enum DynamicValueDataType {
    case bool
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
        let isNSNumber = T.self == NSNumber.self
        return isDouble || isFloat || isInt || isNSNumber
    }

    public static func extractType() -> DynamicValueDataType {
        let dataType = type(of: Data.self)
        if dataType is Bool {
            return .bool
        } else if isNumeric(dataType) {
            return .number
        } else if dataType is String {
            return .string
        } else {
            return .decodable
        }
    }
}
