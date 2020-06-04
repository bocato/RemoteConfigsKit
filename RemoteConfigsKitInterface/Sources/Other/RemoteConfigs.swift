import Foundation

// This will be generated from a json in the near future...
public enum RemoteConfigs {
    public static func register(on manager: RemoteConfigsManaging) {
        manager.register(RemoteConfigs.Example.self)
    }

    // MARK: - Example

    public struct Example: RemoteConfigType {
        public typealias Data = ConfigData
        public static var name: String { "remote_config_example" }
        public static var provider: RemoteConfigsDataProviderIdentifier { .firebase }
        public static var defaultValue: Data {
            .init(
                value: false,
                otherValue: "some value"
            )
        }

        public static var description: String {
            """
            Describes the remote config.
            """
        }

        public struct ConfigData: Codable {
            public let value: Bool
            public let otherValue: String

            private enum CodingKeys: String, CodingKey {
                case value
                case otherValue = "other_value"
            }
        }
    }
}
