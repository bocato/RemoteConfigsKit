import Foundation

/// Defines the RemoteConfigsManaging contract
public protocol RemoteConfigsManaging {
    /// Starts the manager
    func start() throws

    /// Registers a providers, that will fetch the config values
    /// - Parameter provider: the provider
    func register(provider: RemoteConfigsDataProvider)

    /// Registers a ValueType
    /// - Parameter dynamicValue: the type
    func register<T: DynamicValue>(_ dynamicValue: T.Type)

    /// Overrides the value, for some type
    /// - Parameters:
    ///   - type: the type
    ///   - value: the new value
    func override<T: DynamicValue>(type: T.Type, with value: T.Data) throws

    /// Resets the overriden values
    func reset()
}
