import Foundation

/// Defines the RemoteConfigProvider contract
public protocol RemoteConfigProvider {
    /// Returns a sync value
    /// - Parameter remoteConfig: the config type to be returned
    func get<T>(_ remoteConfig: T.Type) -> T.Data where T: RemoteConfigType
}
