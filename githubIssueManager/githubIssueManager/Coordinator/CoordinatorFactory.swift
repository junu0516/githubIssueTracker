import Foundation

protocol CoordinatorFactoryApplicable {
    
    static func createCoordinator<T:Coordinator>(type: T.Type) -> Coordinator?
}

final class CoordinatorFactory: CoordinatorFactoryApplicable {
    
    private static let coordinatorType: [ObjectIdentifier:Coordinator.Type] = [
        ObjectIdentifier(AppCoordinator.self): AppCoordinator.self,
        ObjectIdentifier(LoginCoordinator.self): LoginCoordinator.self,
        ObjectIdentifier(MainCoordinator.self): MainCoordinator.self
    ]
    
    static func createCoordinator<T:Coordinator>(type: T.Type) -> Coordinator? {
        guard let coordinator = coordinatorType[ObjectIdentifier(type)] else { return nil }

        return coordinator.init()
    }
}
