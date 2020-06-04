import Foundation

protocol SecretBusinessLogic {
    func fetchConfigs(request: Secret.Fetch.Request)
    func fetchEditAlert(request: Secret.Alert.Request)
    func updateValue(request: Secret.Update.Request)
}

protocol SecretDataStore {
    var configurations: [Secret.Configuration] { get set }
    var selectedIndex: Int? { get set }
}

final class SecretInteractor: SecretBusinessLogic, SecretDataStore {
    private let worker: SecretWorkerProtocol
    private let presenter: SecretPresentationLogic

    init(
        worker: SecretWorkerProtocol,
        presenter: SecretPresentationLogic
    ) {
        self.worker = worker
        self.presenter = presenter
    }

    // MARK: - SecretDataStore

    var configurations: [Secret.Configuration] = []
    var selectedIndex: Int?

    // MARK: - SecretBusinessLogic

    func fetchConfigs(request: Secret.Fetch.Request) {
        let configsInMemory = worker.fetchConfigsInMemory()
        let secretConfigurations: [Secret.Configuration] = configsInMemory.map {
            let originalValue = $0.stringValue ?? "NULL"
            let secretValue = worker.fetchValueFromProviders(for: $0.name) ?? "NULL"
            return .init(
                name: $0.name,
                originalValue: originalValue,
                currentValue: secretValue
            )
        }
        if !request.searchText.isEmpty {
            configurations = secretConfigurations.filter {
                $0.name.contains(searchText: request.searchText)
            }
        } else {
            configurations = secretConfigurations
        }
        presenter.presentConfigs(response: .init(configs: configurations))
    }

    func fetchEditAlert(request: Secret.Alert.Request) {
        guard let config = configurations[safe: request.atIndex] else {
            selectedIndex = nil
            presenter.presentEditErrorAlert(response: .init())
            return
        }

        selectedIndex = request.atIndex
        presenter.presentEditAlert(response: .init(config: config))
    }

    func updateValue(request: Secret.Update.Request) {
        guard let index = selectedIndex else {
            presenter.presentUpdateErrorAlert(response: .init())
            return
        }

        guard let selectedConfig = configurations[safe: index] else {
            presenter.presentUpdateErrorAlert(response: .init())
            return
        }

        worker.setMemoryValue(for: selectedConfig.name, newValue: request.newValue)

        let newConfig = Secret.Configuration(
            name: selectedConfig.name,
            originalValue: selectedConfig.originalValue,
            currentValue: request.newValue
        )

        configurations[index] = newConfig
        presenter.presentConfig(response: .init(config: newConfig, atIndex: index))
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        guard index >= startIndex, index < endIndex else { return nil }
        return self[index]
    }
}

private extension String {
    func contains(searchText: String) -> Bool {
        let pattern = searchText.reduce("") {
            $0 + "\($1).*"
        }
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else { return false }
        return regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: count)) > 0
    }
}
