import Foundation

protocol SecretWorkerProtocol {
    func fetchConfigsInMemory() -> [RemoteConfigValue]
    func fetchValueFromProviders(for key: String) -> String?
    func setMemoryValue(for key: String, newValue: String)
}

final class SecretWorker: SecretWorkerProtocol {
    private let remoteConfigsController: RemoteConfigsControlling

    init(
        remoteConfigsController: RemoteConfigsControlling
    ) {
        self.remoteConfigsController = remoteConfigsController
    }

    // MARK: - SecretWorkerProtocol

    func fetchConfigsInMemory() -> [RemoteConfigValue] {
        remoteConfigsController.allConfigs().sorted { $0.name < $1.name }
    }

    func fetchValueFromProviders(for key: String) -> String? {
        let allConfigs = remoteConfigsController.allConfigs()
        guard let configRegister = allConfigs.first(where: { $0.name == key }) else { return nil }

        let type = configRegister.dataType
        let providers = remoteConfigsController.providers
        guard
            let providerWithValue = providers.first(where: { $0.getStringValue(ofType: type, onKey: key) != nil }),
            let stringValue = providerWithValue.getStringValue(ofType: type, onKey: key)
        else { return nil }
        return stringValue
    }

    func setMemoryValue(for key: String, newValue: String) {
        let storage = remoteConfigsController.storage
        storage.set(dynamicVariable: key, with: newValue)
    }
}
