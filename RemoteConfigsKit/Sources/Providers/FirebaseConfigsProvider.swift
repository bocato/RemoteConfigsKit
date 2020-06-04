import FirebaseCore
import FirebaseRemoteConfig
import Foundation
import RemoteConfigsKit
import RemoteConfigsKitInterface

public enum FirebaseConfigsProviderError: Error {
    case invalidGoogleServicePlist
}

public final class FirebaseConfigsProvider: RemoteConfigsDataProvider {
    // MARK: - Public Properties

    public var identifier: RemoteConfigsDataProviderIdentifier { .firebase }
    public private(set) var lastSuccessfullFetchTimestamp: Date?

    // MARK: - Properties

    private let googleServicePlistBundle: Bundle
    private let firebaseReference: FirebaseApp.Type
    private let firebaseRemoteConfig: FirebaseRemoteConfig.RemoteConfig
    private let parser: DynamicValueParsing
    private let queue: DispatchQueue

    // MARK: - Initialization

    public convenience init(
        googleServicePlistBundle: Bundle = .main,
        queue: DispatchQueue = .main
    ) {
        self.init(
            googleServicePlistBundle: googleServicePlistBundle,
            firebaseReference: FirebaseApp.self,
            firebaseRemoteConfig: .remoteConfig(),
            parser: DynamicValueParser(),
            queue: queue
        )
    }

    init(
        googleServicePlistBundle: Bundle,
        firebaseReference: FirebaseApp.Type,
        firebaseRemoteConfig: FirebaseRemoteConfig.RemoteConfig,
        parser: DynamicValueParsing,
        queue: DispatchQueue
    ) {
        self.googleServicePlistBundle = googleServicePlistBundle
        self.firebaseReference = firebaseReference
        self.firebaseRemoteConfig = firebaseRemoteConfig
        self.parser = parser
        self.queue = queue
    }

    // MARK: - Public Methods

    public func start(then handle: ((Error?) -> Void)?) {
        do {
            try loadFirebaseIfNeeded()
            fetchFirebaseRemoteConfigValues(then: handle)
        } catch {
            handle?(error)
        }
    }

    public func get<T>(_: T.Type) -> T.Data? where T: DynamicValue {
        let type = T.extractType()
        let key = T.name
        guard let stringValue = getStringValue(ofType: type, forKey: key) else {
            return nil
        }
        let parsedValue: T.Data? = try? parser.decode(string: stringValue)
        return parsedValue
    }

    public func getStringValue(ofType type: DynamicValueDataType, forKey key: String) -> String? {
        let configValue = firebaseRemoteConfig.configValue(forKey: key)
        switch type {
        case .boolean:
            let boolString = configValue.boolValue.description
            return boolString
        case .string:
            let stringValue = configValue.stringValue
            return stringValue
        case .number:
            let numberString = configValue.numberValue?.stringValue
            return numberString
        case .decodable:
            let jsonString = decodeJSONString(from: configValue)
            return jsonString
        }
    }

    private func decodeJSONString(from config: FirebaseRemoteConfig.RemoteConfigValue) -> String? {
        if let jsonValue = config.jsonValue,
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonValue, options: .fragmentsAllowed) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } else if !config.dataValue.isEmpty {
            let dataString = String(data: config.dataValue, encoding: .utf8)
            return dataString
        } else {
            let stringValue = config.stringValue
            return stringValue
        }
    }

    // MARK: - Firebase Loading Logic

    private func loadFirebaseIfNeeded() throws {
        guard firebaseReference.app() == nil else { return }
        let containsGoogleServicePlist = googleServicePlistBundle.url(
            forResource: "GoogleService-Info",
            withExtension: "plist"
        ) != nil
        guard containsGoogleServicePlist else {
            throw FirebaseConfigsProviderError.invalidGoogleServicePlist
        }
        firebaseReference.configure()
    }

    private func fetchFirebaseRemoteConfigValues(then handle: ((Error?) -> Void)?) {
        firebaseRemoteConfig.configSettings = .init()

        var firebaseError: Error?
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        firebaseRemoteConfig.fetch { [weak self] status, error in
            dispatchGroup.leave()
            if status != .success || error != nil {
                firebaseError = error
                let logMessage = "FirebaseRemoteConfig failed to fetch with status: \(status).\nError:\n \(String(describing: error))"
                debugPrint(logMessage)
            } else {
                debugPrint("[REMOTE CONFIG] FirebaseRemoteConfig fetch() succeeded.")
                self?.lastSuccessfullFetchTimestamp = Date()
                dispatchGroup.enter()
                self?.firebaseRemoteConfig.activate {
                    if let activationError = activationError {
                        let logMessage = "FirebaseRemoteConfig Activate returned an error.\nError:\n \(String(describing: error))"
                        debugPrint(logMessage)
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: queue) {
            handle?(firebaseError)
        }
    }
}
