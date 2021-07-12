import UIKit

// MARK: Interface

protocol IMainCoordinator: class { func start() }

// MARK: Implementation

final class MainCoordinator: IMainCoordinator {
    private let navigationController = UINavigationController()
    var rootViewController : UIViewController { navigationController }
    private lazy var injectionContainer = HearXAppDependecyContainer()
    
    func start() { showHomeScreen() }
    
   private func showHomeScreen () {
        let homeViewController = injectionContainer.makeHomeViewController()
        navigationController.pushViewController(homeViewController, animated: false)
        homeViewController.didPressStart = { [weak self] in self?.showTestViewController() }
    }
    
   private func showTestViewController() {
        let hearingTestViewController = injectionContainer.makeHearingTestViewController()
        navigationController.pushViewController(hearingTestViewController, animated: true)
    }
}
