import Foundation

final class IssueInsertViewModel: BasicViewModel {
    
    struct Input {
        let repoInfoRequested = Observable<Bool>()
        let milestones = Observable<[Milestone]>()
        let labels = Observable<[Label]>()
        let assignees = Observable<[Assignee]>()
        let saveButtonTapped = Observable<Bool>()
        let labelFieldTapped = Observable<Bool>()
        let milestoneFieldTapped = Observable<Bool>()
        let assigneeFieldTapped = Observable<Bool>()
        let titleUpdated = Observable<String>()
        let bodyUpdated = Observable<String>()
        let closingViewRequested = Observable<Bool>()
        let segmentIndexSelected = Observable<Int>()
    }
    
    struct Output {
        let selectedMilestones = Observable<[Milestone]>()
        let selectedLabels = Observable<[Label]>()
        let selectedAssignees = Observable<[Assignee]>()
        let updatedTitle = Observable<String>()
        let updatedBody = Observable<String>()
        let issueInsertResult = Observable<Bool>()
        let markdownPreview = Observable<Bool>()
    }
    
    let input = Input()
    let output = Output()
    private let repository: IssueInsertRepository
    private weak var navigation: IssueNavigation?
    
    init(repository: IssueInsertRepository = IssueInsertRepository(),
         navigation: IssueNavigation? = nil) {
        self.repository = repository
        self.navigation = navigation
        bind()
    }
    
    private func bind() {
        
        input.repoInfoRequested.bind { [weak self] isRequested in
            guard isRequested == true else { return }
            DispatchQueue.global(qos: .background).sync {
                self?.fetchRepoInfo()
            }
        }
        
        input.milestoneFieldTapped.bind { [weak self] isTapped in
            guard isTapped == true else { return }
            let milestones = self?.input.milestones.value ?? []
            self?.navigation?.showInfoSelectView(models: milestones, allowsMultipleSelection: false) { selectedIndexList in
                self?.saveSelectedInfo(infoType: .milestone, selectedIndexList: selectedIndexList)
            }
        }
        
        input.labelFieldTapped.bind { [weak self] isTapped in
            guard isTapped == true else { return }
            let labels = self?.input.labels.value ?? []
            self?.navigation?.showInfoSelectView(models: labels, allowsMultipleSelection: true) { selectedIndexList in
                self?.saveSelectedInfo(infoType: .label, selectedIndexList: selectedIndexList)
            }
        }
        
        input.assigneeFieldTapped.bind { [weak self] isTapped in
            guard isTapped == true else { return }
            let assignees = self?.input.assignees.value ?? []
            self?.navigation?.showInfoSelectView(models: assignees, allowsMultipleSelection: true) { selectedIndexList in
                self?.saveSelectedInfo(infoType: .assignee, selectedIndexList: selectedIndexList)
            }
        }
        
        input.titleUpdated.bind { [weak self] titleText in
            self?.output.updatedTitle.value = titleText
        }
        
        input.bodyUpdated.bind { [weak self] bodyText in
            self?.output.updatedBody.value = bodyText
        }
        
        input.saveButtonTapped.bind { [weak self] isTapped in
            guard isTapped == true else { return }
            self?.requestAddingIssue()
        }
        
        input.closingViewRequested.bind { [weak self] isReqeusted in
            guard isReqeusted == true else { return }
            self?.navigation?.goBackToIssueList()
        }
        
        input.segmentIndexSelected.bind { [weak self] index in
            
            self?.output.markdownPreview.value =  index == 1 ? true : false
        }
    }
    
    private func fetchRepoInfo() {
        repository.requestLabels { [weak self] labels in
            self?.input.labels.value = labels
        }
        
        repository.requestMilestones { [weak self] milestones in
            self?.input.milestones.value = milestones
        }
        
        repository.requestAssignees { [weak self] assignees in
            self?.input.assignees.value = assignees
        }
    }
    
    private func saveSelectedInfo(infoType:InfoType, selectedIndexList: [Int]) {
        
        switch infoType {
        case .milestone:
            updateSelectedMilestones(selectedIndexList: selectedIndexList)
        case .label:
            updateSelectedLabels(selectedIndexList: selectedIndexList)
        case .assignee:
            updateSelectedAssignees(selectedIndexList: selectedIndexList)
        }
    }
    
    private func requestAddingIssue() {
        
        guard let labels = output.selectedLabels.value,
              let assignees = output.selectedAssignees.value,
              let milestone = output.selectedMilestones.value?[0],
              let title = output.updatedTitle.value,
              let body = output.updatedBody.value else { return }
        
        let issueRequest = IssueRequest(title: title , body: body, labels: labels, assignees: assignees, milestone: milestone)
        repository.requestAddingIssue(issue: issueRequest) { [weak self] in
            self?.output.issueInsertResult.value = true
        }
    }
}

extension IssueInsertViewModel {
    
    private enum InfoType {
        case milestone
        case label
        case assignee
    }

    private func updateSelectedMilestones(selectedIndexList: [Int]) {
        guard let milestones = input.milestones.value else { return }
        let selected = selectedIndexList.map { milestones[$0] }
        output.selectedMilestones.value = selected
    }
    
    private func updateSelectedLabels(selectedIndexList: [Int]) {
        guard let labels = input.labels.value else { return }
        let selected = selectedIndexList.map { labels[$0] }
        output.selectedLabels.value = selected
    }
    
    private func updateSelectedAssignees(selectedIndexList: [Int]) {
        guard let assignees = input.assignees.value else { return }
        let selected = selectedIndexList.map { assignees[$0] }
        output.selectedAssignees.value = selected
    }
}
