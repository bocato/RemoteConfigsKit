import Firebase
import RemoteConfigsKit
import RemoteConfigsKitInterface
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupRemoteConfigs(for: scene)
    }

    private func setupRemoteConfigs(for scene: UIScene) {
        //        FirebaseApp.configure()
        //
        //        let manager = RemoteConfigsManager.shared
        //
        //        FeatureFlags.register(on: manager)
        //        RemoteConfigs.register(on: manager)
        //
        //        let firebaseProvider = FirebaseConfigsProvider()
        //        firebaseProvider.start { error in
        //            debugPrint(error.debugDescription)
        //        }
        //
        //        manager.register(provider: firebaseProvider)
        //
        //        do {
        //            try manager.start()
        //            setupInitialController(for: scene)
        //        } catch {
        //            debugPrint(String(describing: error))
        //        }
    }

    private func setupInitialController(for scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let secretViewController = RemoteConfigsManager.buildSecretViewController()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = secretViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}
