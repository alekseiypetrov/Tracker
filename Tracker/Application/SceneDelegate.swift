import UIKit

protocol SceneDelegateProtocol {
    func routeFromOnboardingToMainPage()
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let firstEnterKey = "firstEnter"
    private let keyOfFilter = "selectedFilter"

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let wasFirstEnter = UserDefaults.standard.bool(forKey: firstEnterKey)
        window.rootViewController = wasFirstEnter ? TabBarController() : OnboardingViewController(sceneDelegate: self)
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        UserDefaults.standard.setValue(0, forKey: keyOfFilter)
    }
}

extension SceneDelegate: SceneDelegateProtocol {
    func routeFromOnboardingToMainPage() {
        guard let window 
        else {
            assertionFailure("Не удалось получить window из SceneDelegate")
            return
        }
        UserDefaults.standard.setValue(true, forKey: firstEnterKey)
        UIView.transition(with: window,
                          duration: 0.15,
                          options: .transitionCrossDissolve,
                          animations: {
            window.rootViewController = TabBarController()
        })
    }
}
