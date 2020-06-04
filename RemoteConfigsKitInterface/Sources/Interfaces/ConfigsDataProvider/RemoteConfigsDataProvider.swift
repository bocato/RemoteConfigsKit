import Foundation
import RemoteConfigsKitInterface

public protocol RemoteConfigsDataProvider {
    /// Defines the identifier of the provider
    var identifier: RemoteConfigsDataProviderIdentifier { get }
    var lastSuccessfullFetchTimestamp: Date? { get }

    /// Starts a provider, fetching it's values
    func start(then handle: ((Error?) -> Void)?)
    /// Gets a dynamic value from a said provider
    func get<T: DynamicValue>(_: T.Type) -> T.Data?
    /// Gets the string value of a DynamicValue
    func getStringValue(ofType type: DynamicValueDataType, forKey key: String) -> String?
}

extension RemoteConfigsDataProvider {
    public func start() throws {
        try start(then: nil)
    }
}
