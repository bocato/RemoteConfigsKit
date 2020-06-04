import Foundation
import RemoteConfigsKitInterface

protocol RemoteConfigsControlling {
    var providers: [RemoteConfigsDataProvider] { get }
    var storage: DynamicValueStorage { get }

    func start() throws
    func register(provider: RemoteConfigsDataProvider)
    func register<T: DynamicValue>(_ dynamicValue: T.Type)
    func get<T: DynamicValue>(_ config: T.Type) -> T.Data
    func override<T: DynamicValue>(type: T.Type, with value: T.Data) throws
    func allConfigs() -> [RemoteConfigValue]
    func reset()
}

public enum RemoteConfigsControllerError: Error {
    case emptyProviders
}

final class RemoteConfigsController: RemoteConfigsControlling {
    // MARK: - Dependencies

    private(set) var providers: [RemoteConfigsDataProvider]
    private(set) var storage: DynamicValueStorage

    // MARK: - Private Properties

    private var registeredConfigs: [RemoteConfigValue] = []

    // MARK: - Initialization

    init(
        providers: [RemoteConfigsDataProvider] = [],
        storage: DynamicValueStorage = InMemoryStorage(name: "memory")
    ) {
        self.providers = providers
        self.storage = storage
    }

    // MARK: - Public Methods

    func start() throws {
        guard !providers.isEmpty else {
            throw RemoteConfigsControllerError.emptyProviders
        }
    }

    func register(provider: RemoteConfigsDataProvider) {
        guard !providers.contains(where: { $0.identifier == provider.identifier }) else { return }
        providers.append(provider)
    }

    func register<T: DynamicValue>(_ dynamicValue: T.Type) {
        let name = T.name
        let stringValue = T.stringValue
        let dataType = T.extractType()
        let description = T.description
        let provider = T.provider
        let configValueRegister = RemoteConfigValue(
            name: name,
            stringValue: stringValue,
            dataType: dataType,
            origin: .defaultValue,
            description: description,
            provider: provider
        )
        registeredConfigs.append(configValueRegister)
    }

    func get<T: DynamicValue>(_ config: T.Type) -> T.Data {
        var value = config.defaultValue
        if let storedValue = storage.get(config) {
            value = storedValue
        } else if let providerValue = getConfigFromFirstProvider(config) {
            value = providerValue
        }
        return value
    }

    func override<T: DynamicValue>(type: T.Type, with value: T.Data) throws {
        try storage.override(type, with: value)
    }

    func allConfigs() -> [RemoteConfigValue] {
        var registered = [RemoteConfigValue]()
        registeredConfigs.forEach { config in
            var origin = config.origin
            var value = config.stringValue
            if let storedValue = storage.get(dynamicValue: config.name) {
                value = config.dataType.parse(storedValue)
                origin = .storage(named: storage.identifier)
            } else if let providerValue = getStringValueFromProvider(for: config) {
                value = providerValue
                origin = .provider(named: config.provider)
            }
            let newConfig = RemoteConfigValue(
                name: config.name,
                stringValue: value,
                dataType: config.dataType,
                origin: origin,
                description: config.description,
                provider: config.provider
            )
            registered.append(newConfig)
        }
        return registered
    }

    func reset() {
        storage.reset()
    }

    // MARK: - Private

    private func getStringValueFromProvider(for config: RemoteConfigValue) -> String? {
        let type = config.dataType
        let key = config.name
        guard
            let providerWithValue = providers.first(where: { $0.identifier == config.provider }),
            let stringValue = providerWithValue.getStringValue(ofType: type, forKey: key)
        else { return nil }
        return stringValue
    }

    private func getConfigFromFirstProvider<T: DynamicValue>(_ config: T.Type) -> T.Data? {
        let firstProviderWithValue = providers.first(where: { $0.identifier == T.provider })
        let configValue = firstProviderWithValue?.get(config)
        return configValue
    }
}
