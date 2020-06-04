import XCTest
import RemoteConfigsKitInterface
@testable import RemoteConfigsKit

final class RemoteConfigValueTests: XCTestCase {
    
    func test_parse_boolStringValue_shouldReturnExpectedValues() {
        // Given
        let stringValues: [String] = ["1", "yes", "true", "false"]
        let expectedValues = ["true", "true", "true", "false"]
        // When
        let parsedValues = stringValues.map { DynamicValueDataType.boolean.parse($0) }
        // Then
        XCTAssertEqual(parsedValues, expectedValues)
    }
    
    func test_parse_notBooleanValue_shouldReturnItself() {
        // Given
        let notABoolDataType: DynamicValueDataType = .decodable
        let someValue = "value"
        // When
        let parsedValue = notABoolDataType.parse(someValue)
        // Then
        XCTAssertEqual(parsedValue, someValue)
    }
    
    func test_origin_provider_name_shouldReturnAssociatedValue() {
        // Given
        let providerName = "providerName"
        let origin: RemoteConfigValue.Origin = .provider(named: providerName)
        // When / Then
        XCTAssertEqual(providerName, origin.name)
    }
    
    func test_origin_storage_name_shouldReturnAssociatedValue() {
        // Given
        let storageName = "storageName"
        let origin: RemoteConfigValue.Origin = .provider(named: storageName)
        // When / Then
        XCTAssertEqual(storageName, origin.name)
    }
    
    func test_origin_defaultValue_name_shouldReturnAssociatedValue() {
        // Given
        let defaultValue = "Default Value"
        let origin: RemoteConfigValue.Origin = .defaultValue
        // When / Then
        XCTAssertEqual(defaultValue, origin.name)
    }

}

// MARK: - Test Doubles

extension RemoteConfigValue {
    static func fixture(
        name: String = "mock",
        stringValue: String? = nil,
        dataType: DynamicValueDataType = .decodable,
        origin: Origin = .defaultValue,
        description: String = "description",
        provider: RemoteConfigsDataProviderIdentifier = "mock"
    ) -> RemoteConfigValue {
        return .init(
            name: name,
            stringValue: stringValue,
            dataType: dataType,
            origin: origin,
            description: description,
            provider: provider
        )
    }
}
