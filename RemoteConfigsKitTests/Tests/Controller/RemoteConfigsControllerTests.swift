import XCTest
import RemoteConfigsKitInterface
@testable import RemoteConfigsKit

final class RemoteConfigsControllerTests: XCTestCase {
    
    // MARK: - Properties
    
    private let remoteConfigsDataProviderDummy = RemoteConfigsDataProviderDummy()
    
    // MARK: - Tests
    
    func test_start_noProviders_shouldThrowError() {
        // Given
        let sut = buildSUT(providers: [])
        // When
        var errorThrown: RemoteConfigsControllerError?
        do {
            try sut.start()
            XCTFail("Expected an error")
        } catch {
            errorThrown = error as? RemoteConfigsControllerError
        }
        // Then
        guard case .emptyProviders = errorThrown else {
            XCTFail("Expected .emptyProviders, but got \(String(describing: errorThrown))")
            return
        }
    }
    
    func test_start_providers_shouldNotThrowError() {
        // Given
        let sut = buildSUT(providers: [remoteConfigsDataProviderDummy])
        // When
        var errorThrown: RemoteConfigsControllerError?
        do {
            try sut.start()
        } catch {
            errorThrown = error as? RemoteConfigsControllerError
        }
        // Then
        XCTAssertNil(errorThrown)
    }
    
    func test_register_newProvider_shouldUpdate_providers() {
        // Given
        let sut = buildSUT()
        // When
        sut.register(provider: remoteConfigsDataProviderDummy)
        // Then
        XCTAssertEqual(sut.providers.count, 1)
    }
    
    func test_register_existentProvider_shouldNotUpdate_providersCount() {
        // Given
        let sut = buildSUT(providers: [remoteConfigsDataProviderDummy])
        let initialProvidersCount = sut.providers.count
        // When
        sut.register(provider: remoteConfigsDataProviderDummy)
        // Then
        XCTAssertEqual(sut.providers.count, initialProvidersCount)
    }
    
    func test_registerDynamicValue_shouldUpdateAllConfigsCount() {
        // Given
        let sut = buildSUT()
        let initialConfigsCount = sut.allConfigs().count
        // When
        sut.register(DummyDynamicValue.self)
        // Then
        XCTAssertGreaterThan(sut.allConfigs().count, initialConfigsCount)
    }
    
    // MARK: - Testing Helpers
    
    private func buildSUT(
        providers: [RemoteConfigsDataProvider] = [],
        storage: DynamicValueStorage? = nil
    ) -> RemoteConfigsController {
        let sut = RemoteConfigsController(
            providers: providers,
            storage: InMemoryStorage(name: "InMemoryStorageDummy")
        )
        return sut
    }
    
}

// MARK: - Testing Doubles

final class RemoteConfigsDataProviderDummy: RemoteConfigsDataProvider {
    
    var identifier: RemoteConfigsDataProviderIdentifier { "RemoteConfigsDataProviderDummy" }
    var lastSuccessfullFetchTimestamp: Date? = nil
    
    func start(then handle: ((Error?) -> Void)?) {}
    func get<T>(_: T.Type) -> T.Data? where T : DynamicValue { nil}
    func getStringValue(
        ofType type: DynamicValueDataType,
        forKey key: String
    ) -> String? { nil }
    
}

struct DummyDynamicValue: DynamicValue {
    typealias Data = String
    static var name: String { "DummyDynamicValue" }
    static var provider: RemoteConfigsDataProviderIdentifier { .mock }
    static var defaultValue: String { "dummy" }
}

extension RemoteConfigsDataProviderIdentifier {
    static let mock: RemoteConfigsDataProviderIdentifier = "mock"
}
