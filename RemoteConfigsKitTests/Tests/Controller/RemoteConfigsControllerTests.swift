import XCTest
import RemoteConfigsKitInterface
@testable import RemoteConfigsKit

final class RemoteConfigsControllerTests: XCTestCase {
    
    // MARK: - Properties
    
    // MARK: - Tests
    
    func test_() {
        
    }
    
    // MARK: - Testing Helpers
    
    private func buildSUT(
        providers: [RemoteConfigsDataProvider]? = nil,
        storage: DynamicValueStorage? = nil
    ) -> RemoteConfigsController {
        let sut = RemoteConfigsController(
            providers: providers ?? [RemoteConfigsDataProviderDummy()],
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
