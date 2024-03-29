import Foundation

enum Path: CustomStringConvertible {
    case githubLogin(clientId: String)
    case githubAccessToken
    case issues(owner: String, repo: String)
    case milestones(owner: String, repo: String)
    case labels(owner: String, repo: String)
    case assignees(owner: String, repo: String)
    
    var description: String {
        switch self {
        case .githubLogin(let clientId):
            return "https://github.com/login/oauth/authorize?client_id=\(clientId)&scope=user,repo"
        case .githubAccessToken:
            return "https://github.com/login/oauth/access_token"
        case .issues(let owner, let repo):
            return "https://api.github.com/repos/\(owner)/\(repo)/issues"
        case .milestones(let owner, let repo):
            return "https://api.github.com/repos/\(owner)/\(repo)/milestones"
        case .labels(let owner, let repo):
            return "https://api.github.com/repos/\(owner)/\(repo)/labels"
        case .assignees(let owner, let repo):
            return "https://api.github.com/repos/\(owner)/\(repo)/assignees"
        }
    }
}
