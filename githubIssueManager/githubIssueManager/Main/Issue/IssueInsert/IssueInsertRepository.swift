import Foundation

struct IssueInsertRepository {
    
    private let networkManager: NetworkManagable
    private let objectConverter: ObjectConvertible
    
    @UserDefault(key: .authToken)
    private var accessToken: String
    
    init(networkManager: NetworkManagable = NetworkManager(),
         objectConverter: ObjectConvertible = ObjectConverter()) {
        self.networkManager = networkManager
        self.objectConverter = objectConverter
    }
    
    func requestMilestones(completion: @escaping ([Milestone]) -> Void) {
        let target = NetworkTarget(path: .milestones(owner: "junu0516", repo: "GithubIssueManager"),
                                   method: .get,
                                   paramteterType: .json,
                                   headers: ["Accept":"application/vnd.github.v3+json",
                                             "Authorization":"token \(accessToken)"])
        
        networkManager.request(target: target,
                               parameters: Optional<String>.none) { result in
            switch result {
            case .success(let data):
                let milestones = objectConverter.convertJsonToObject(from: data, to: [Milestone].self)
                completion(milestones ?? [])
            case .failure(let error):
                Log.error("\(error)")
            }
        }
    }
    
    func requestLabels(completion: @escaping ([Label]) -> Void) {
        let target = NetworkTarget(path: .labels(owner: "junu0516", repo: "GithubIssueManager"),
                                   method: .get,
                                   paramteterType: .json,
                                   headers: ["Accept":"application/vnd.github.v3+json",
                                             "Authorization":"token \(accessToken)"])
        
        networkManager.request(target: target,
                               parameters: Optional<String>.none) { result in
            switch result {
            case .success(let data):
                let labels = objectConverter.convertJsonToObject(from: data, to: [Label].self)
                completion(labels ?? [])
            case .failure(let error):
                Log.error("\(error)")
            }
        }
    }
    
    func requestAssignees(completion: @escaping ([Assignee]) -> Void) {
        let target = NetworkTarget(path: .assignees(owner: "junu0516", repo: "GithubIssueManager"),
                                   method: .get,
                                   paramteterType: .json,
                                   headers: ["Accept":"application/vnd.github.v3+json",
                                             "Authorization":"token \(accessToken)"])
        networkManager.request(target: target,
                               parameters: Optional<String>.none) { result in
            switch result {
            case .success(let data):
                let assignees = objectConverter.convertJsonToObject(from: data, to: [Assignee].self)
                completion(assignees ?? [])
            case .failure(let error):
                Log.error("\(error)")
            }
        }
    }
    
    func requestAddingIssue(issue: IssueRequest, completion: @escaping () -> Void) {
        
        let target = NetworkTarget(path: .issues(owner: "junu0516", repo: "GithubIssueManager"),
                                   method: .post,
                                   paramteterType: .json,
                                   headers: ["Accept":"application/vnd.github.v3+json",
                                             "Authorization":"token \(accessToken)"])
        
        networkManager.request(target: target, parameters: issue) { result in
            
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                Log.error("\(error.localizedDescription)")
            }
        }
    }
}
