import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let firstEnterKey = "firstEnter"

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let wasFirstEnter = UserDefaults.standard.bool(forKey: firstEnterKey)
        window.rootViewController = wasFirstEnter ? TabBarController() : OnboardingViewController(firstEnterKey)
        window.makeKeyAndVisible()
        self.window = window
    }
}
