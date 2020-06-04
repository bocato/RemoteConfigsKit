import Foundation
import RemoteConfigsKitInterface

public final class RemoteConfigsManager: RemoteConfigsManaging, FeatureFlagProvider, RemoteConfigProvider {
    // MARK: - Dependencies

    private let controller: RemoteConfigsControlling

    // MARK: - Singleton

    public static let shared = RemoteConfigsManager()

    // MARK: - Private Properties

    private var startCalled = false

    // MARK: - Public Properties

    public var providers: [RemoteConfigsDataProvider] {
        controller.providers
    }

    // MARK: - Initialization

    init() {
        controller = RemoteConfigsController()
    }

    // MARK: - Public API

    public static func buildSecretViewController() -> UIViewController {
        let worker = SecretWorker(
            remoteConfigsController: RemoteConfigsManager.shared.controller
        )
        let presenter = SecretPresenter()
        let interactor = SecretInteractor(
            worker: worker,
            presenter: presenter
        )
        let viewController = SecretViewController(interactor: interactor)
        presenter.view = viewController

        return viewController
    }
}

extension RemoteConfigsManager {
    // MARK: - RemoteConfigsManaging

    public func start() throws {
        guard !startCalled else {
            fatalError("[REMOTE CONFIG] start() can be called only one time.")
        }
        try controller.start()
        startCalled = true
    }

    public func register(provider: RemoteConfigsDataProvider) {
        controller.register(provider: provider)
    }

    public func register<T: DynamicValue>(_ dynamicValue: T.Type) {
        controller.register(dynamicValue)
    }

    public func override<T: DynamicValue>(type: T.Type, with value: T.Data) throws {
        try controller.override(type: type, with: value)
    }

    public func reset() {
        controller.reset()
    }
}

extension RemoteConfigsManager {
    // MARK: - FeatureFlagProvider

    public func get<T>(_ featureFlag: T.Type) -> Bool where T: FeatureFlagType {
        let flag = controller.get(featureFlag)
        return flag
    }
}

extension RemoteConfigsManager {
    // MARK: - RemoteConfigProvider

    public func get<T>(_ remoteConfig: T.Type) -> T.Data where T: RemoteConfigType {
        let config = controller.get(remoteConfig)
        return config
    }
}
