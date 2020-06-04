# RemoteConfigsKit
 
A more complete documentation will be provided **SOON**.

### Basic setup (extracted from the Example app)
```swift
// 1 - Setup firebase
FirebaseApp.configure()

// 2 - Configure the Providers and start them
let firebaseProvider = FirebaseConfigsProvider()
firebaseProvider.start { error in
    debugPrint(error)
}

// 3 - Register the providers
let manager = RemoteConfigsManager.shared
manager.register(provider: firebaseProvider)

// 4 - Start the Controller
do {
    try manager.start()
} catch {
    debugPrint(error)
}
```

### Basic Usage
- To change the configs in memory or just to see what is configured, create a `SecretViewController` like:
```swift
let secretViewController = RemoteConfigsManager.buildSecretViewController()
```

- To be able to interact with the `Manager` using an abstraction you can use `RemoteConfigsManaging` interface.

- If you want to get a `FeatureFlag` value, you can use the `FeatureFlagProvider` interface like this:
```swift
let provider: FeatureFlagProvider = RemoteConfigsManager.shared
let myValue = provider.get(FeatureFlag.CommentTypeAudioEnable.self) 
```
-  If you want to get a `RemoteConfig` value, you can use the `RemoteConfigProvider` interface like this:
```swift
let provider: RemoteConfigProvider = RemoteConfigsManager.shared
let myValue = provider.get(RemoteConfig.AppsFlyerDevKey.self) 
```

- To register a new config, your need to create and register a new value.
1. Create the value:
```swift
public enum FeatureFlag {
    // ...
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
    // ...
}

// or
public enum RemoteConfig {
    // ...
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
    // ...
}
```
**Note:** those structs will be generate from a **json** in the future.

2. Register them on the `RemoteConfigsManager` class.
```swift
func registerFeatureFlagTypes() {
    // ...
   controller.register(FeatureFlag.EnablePocket.self)
   // ...
}

// or

func registerRemoteConfigTypes() {
    // ...
    controller.register(RemoteConfig.PaymentDNSHMG.self)
    // ...
}
```
**Note:** this setup will be generate in the future.
