import XCTest
@testable import githubIssueManager

class AuthenticationTest: XCTestCase {

    private var deepLinkRouter: DeepLinkRouter!
    private var networkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        self.networkManager = MockNetworkManager()
        self.deepLinkRouter = DeepLinkRouter(appCoordinator: nil,
                                             networkManager: self.networkManager)
    }
    
    func test_initializing_auth_request() {
        let authRequest = AuthRequest()
        
        XCTAssertNotNil(authRequest.clientId, authRequest.clientSecret)
        XCTAssertFalse(authRequest.clientId.isEmpty)
        XCTAssertFalse(authRequest.clientSecret.isEmpty)
    }
    
    func test_requesting_access_token() throws {        
        XCTAssertNil(deepLinkRouter.authToken.value)
        
        networkManager.shouldFail = false
        deepLinkRouter.authCode.value = "someCode"

        XCTAssertNotNil(deepLinkRouter.authToken.value)
        
        let token = try XCTUnwrap(deepLinkRouter.authToken.value)
        XCTAssertEqual(token, "mock_access_token")
    }

}

