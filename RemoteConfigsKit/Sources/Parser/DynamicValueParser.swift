import Foundation

public typealias DynamicValueParsing = DynamicValueEncoding & DynamicValueDecoding

public protocol DynamicValueEncoding {
    /// Encondes e value to string
    /// - Parameter value: the value to be encoded
    func encode<T>(_ value: T) throws -> String where T: Encodable

    /// Encodes a JSON to string
    /// - Parameter json: the json value to be encoded
    func encodeJSON(_ json: Any) throws -> String?
}

public protocol DynamicValueDecoding {
    /// Decodes a string to a specifiec value
    /// - Parameter string: the string to be transformed into a value
    func decode<T: Codable>(string: String) throws -> T

    /// Decodes a string, to become a JSONString
    /// - Parameter string: a raw string
    func decodeString(_ string: String) throws -> String
}

public enum DynamicValueParserError: Error {
    case utf8EncodingFailed
    case dictionaryParsingFailed
    case wrappedDecodingFailed
}

public final class DynamicValueParser: DynamicValueDecoding, DynamicValueEncoding {
    // MARK: - Dependencies

    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let jsonSerializer: JSONSerialization.Type

    // MARK: - Initialization

    public init(
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init(),
        jsonSerializer: JSONSerialization.Type = JSONSerialization.self
    ) {
        self.decoder = decoder
        self.encoder = encoder
        self.jsonSerializer = jsonSerializer
    }

    // MARK: - Public Functions

    public func encode<T>(_ value: T) throws -> String where T: Encodable {
        let dictionary: [String: T] = ["key": value]
        let data = try encoder.encode(value)
        guard let stringValue = String(data: data, encoding: .utf8) else {
            throw DynamicValueParserError.utf8EncodingFailed
        }
        return stringValue
    }

    public func encodeJSON(_ json: Any) throws -> String? {
        let data = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        return string
    }

    public func decode<T: Codable>(string: String) throws -> T {
        guard let data = string.data(using: .utf8) else {
            throw DynamicValueParserError.utf8EncodingFailed
        }
        let dictionaryValue = try? decoder.decode([String: T].self, from: data)
        if let valueFromDictionary = dictionaryValue?["key"] {
            return valueFromDictionary
        }
        return try decodeByWrappingValue(string)
    }

    public func decodeString(_ string: String) throws -> String {
        guard
            let data = string.data(using: .utf8),
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let value = dictionary["key"].flatMap(String.init(describing:))
        else { throw DynamicValueParserError.dictionaryParsingFailed }
        return value
    }

    // MARK: - Private Functions

    // Do this in case of a single value storage encodable type
    private func decodeByWrappingValue<T: Codable>(_ string: String) throws -> T {
        let uniqueValue = mapTypeFromUniqueValue(string)
        let wrappedValue = ["key": uniqueValue]
        do {
            let data = try serializeDictionary(wrappedValue)
            let decodedValue = try decoder.decode([String: T].self, from: data)
            guard let object = decodedValue["key"] else {
                throw DynamicValueParserError.wrappedDecodingFailed
            }
            return object
        } catch {
            throw error
        }
    }

    private func serializeDictionary(_ dictionary: [String: Any]) throws -> Data {
        do {
            let jsonData = try jsonSerializer.data(withJSONObject: dictionary, options: .fragmentsAllowed)
            return jsonData
        } catch {
            throw error
        }
    }

    // This acts similarly to a singleValueEncoder, but in a "brute-force" style
    private func mapTypeFromUniqueValue(_ string: String) -> Any {
        if let boolValue = parseBool(from: string) {
            return boolValue
        } else if let number = parseNumber(from: string) {
            return number
        } else if let json = parseJSON(from: string) {
            return json
        }
        return string
    }

    private func parseBool(from string: String) -> Bool? {
        let cleanString = string.lowercased()
        if ["false", "no"].contains(cleanString) {
            return false
        }
        if ["true", "yes"].contains(cleanString) {
            return true
        }
        return nil
    }

    private func parseNumber(from string: String) -> NSNumber? {
        if let int = Int(string) {
            return NSNumber(value: int)
        } else if let float = Float(string) {
            return NSNumber(value: float)
        } else if let double = Double(string) {
            return NSNumber(value: double)
        }
        return nil
    }

    private func parseJSON(from string: String) -> [String: Any]? {
        guard let data = string.data(using: .utf8) else { return nil }
        let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
        return dictionary
    }
}
