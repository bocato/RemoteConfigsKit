import Foundation
import RemoteConfigsKitInterface

final class InMemoryStorage: DynamicValueStorage {
    // MARK: - Dependencies

    private let parser: DynamicValueParsing

    // MARK: - Public Properties

    var identifier: String

    // MARK: - Private Properties

    private var storage = [String: String]()

    // MARK: - Initialization

    init(
        name: String,
        parser: DynamicValueParsing = DynamicValueParser()
    ) {
        identifier = name
        self.parser = parser
    }

    // MARK: - Public Methods

    func get<T>(_: T.Type) -> T.Data? where T: DynamicValue {
        return try? storage[T.name].flatMap(parser.decode(string:))
    }

    func get(dynamicValue: String) -> String? {
        try? storage[dynamicValue].flatMap(parser.decodeString(_:))
    }

    func override<T>(_: T.Type, with value: T.Data) throws where T: DynamicValue {
        storage[T.name] = try parser.encode(value)
    }

    func set(dynamicVariable: String, with value: String) {
        storage[dynamicVariable] = value
    }

    func clear(dynamicVariable: String) {
        storage.removeValue(forKey: dynamicVariable)
    }

    func reset() {
        storage.removeAll()
    }
}
