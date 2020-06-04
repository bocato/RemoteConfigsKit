import Foundation

/// Defines the FeatureFlagProvider contract
public protocol FeatureFlagProvider {
    /// Returns a sync value for a especified flag type
    /// - Parameter featureFlag: the flag type
    func get<T>(_ featureFlag: T.Type) -> Bool where T: FeatureFlagType
}
