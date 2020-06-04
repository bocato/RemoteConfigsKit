import Foundation

// This will be generated from a json in the near future...
public enum FeatureFlags {
    public static func register(on manager: RemoteConfigsManaging) {
        manager.register(FeatureFlags.Example.self)
    }

    // MARK: - Example

    public struct Example: FeatureFlagType {
        public static var name: String { "feature_flag_example" }
        public static var provider: RemoteConfigsDataProviderIdentifier { .firebase }
        public static var defaultValue: Bool { false }
        public static var description: String {
            """
            TODO: Add descriptions!
            """
        }
    }
}
