import XCTest
@testable import RemoteConfigsKitInterface

final class DynamicValueTests: XCTestCase {
    
    func test_extractType_booleanType_shouldReturnBoolean() {
        // Given
        let booleanType = BooleanDynamicValue.self
        // When
        let returnedType = booleanType.extractType()
        // Then
        XCTAssertEqual(returnedType, .boolean)
    }
    
    func test_extractType_stringType_shouldReturnString() {
        // Given
        let stringType = StringDynamicValue.self
        // When
        let returnedType = stringType.extractType()
        // Then
        XCTAssertEqual(returnedType, .string)
    }
    
    func test_extractType_intType_shouldReturnNumber() {
        // Given
        let intType = IntDynamicValue.self
        // When
        let returnedType = intType.extractType()
        // Then
        XCTAssertEqual(returnedType, .number)
    }
    
    func test_extractType_doubleType_shouldReturnNumber() {
        // Given
        let doubleType = DoubleDynamicValue.self
        // When
        let returnedType = doubleType.extractType()
        // Then
        XCTAssertEqual(returnedType, .number)
    }
    
    func test_extractType_floatType_shouldReturnNumber() {
        // Given
        let floatType = FloatDynamicValue.self
        // When
        let returnedType = floatType.extractType()
        // Then
        XCTAssertEqual(returnedType, .number)
    }
    
    func test_extractType_decodableType_shouldReturnDecodable() {
        // Given
        let decodableType = DecodableDynamicValue.self
        // When
        let returnedType = decodableType.extractType()
        // Then
        XCTAssertEqual(returnedType, .decodable)
    }
    
}

// MARK: - Test Doubles

extension RemoteConfigsDataProviderIdentifier {
    static let mock: RemoteConfigsDataProviderIdentifier = "mock"
}

struct BooleanDynamicValue: DynamicValue {
    typealias Data = Bool
    static var name: String { "BooleanDynamicValue" }
    static var provider: RemoteConfigsDataProviderIdentifier { .mock }
    static var defaultValue: Bool { false }
}

struct StringDynamicValue: DynamicValue {
    typealias Data = String
    static var name: String { "StringDynamicValue" }
    static var provider: RemoteConfigsDataProviderIdentifier { .mock }
    static var defaultValue: String { "string" }
}

struct IntDynamicValue: DynamicValue {
    typealias Data = Int
    static var name: String { "IntDynamicValue" }
    static var provider: RemoteConfigsDataProviderIdentifier { .mock }
    static var defaultValue: Int { 0 }
}

struct DoubleDynamicValue: DynamicValue {
    typealias Data = Double
    static var name: String { "DoubleDynamicValue" }
    static var provider: RemoteConfigsDataProviderIdentifier { .mock }
    static var defaultValue: Double { 0.0 }
}

struct FloatDynamicValue: DynamicValue {
    typealias Data = Float
    static var name: String { "FloatDynamicValue" }
    static var provider: RemoteConfigsDataProviderIdentifier { .mock }
    static var defaultValue: Float { 0.0 }
}

struct DecodableDynamicValue: DynamicValue {
    typealias Data = ValueData
    static var name: String { "DecodableDynamicValue" }
    static var provider: RemoteConfigsDataProviderIdentifier { .mock }
    static var defaultValue: ValueData { .init(key: "key") }
    struct ValueData: Codable {
        let key: String
    }
}
