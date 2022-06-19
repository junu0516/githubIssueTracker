import UIKit

final class IssueListCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    private (set)var navigationController: UINavigationController?
    
    required init() {
        self.navigationController = UINavigationController()
        self.navigationController?.view.backgroundColor = .systemBackground
    }
    
    func start() {
        let viewModel = IssueListViewModel()
        let viewController = IssueListViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
