import UIKit
import SnapKit

final class IssueListViewController: UIViewController {
    
    private var viewModel: IssueListViewModel?
    
    private lazy var issueTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .lightGray
        tableView.register(IssueListTableViewCell.self, forCellReuseIdentifier: IssueListTableViewCell.identifier)
        tableView.dataSource = issueDataSource
        tableView.delegate = self
        return tableView
    }()
    private let issueDataSource = TableViewDataSource<IssueListTableViewCell,IssueListTableViewCellModel>.create()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("필터", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        button.titleLabel?.textAlignment = .right
        return button
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.titleLabel?.textAlignment = .right
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 50)
        button.clipsToBounds = true
        button.layer.cornerRadius = self.view.frame.width*0.2/2
        return button
    }()
    
    convenience init(viewModel: IssueListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setAttributes()
        addViews()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bind() {
        viewModel?.input.issueListRequested.value = true
        
        viewModel?.output.issueViewModels.bind { [weak self]  in
            self?.issueDataSource.items = $0
            self?.issueTableView.reloadData()
        }
        
        addButton.tapped { [weak self] in
            self?.viewModel?.input.addButtonTapped.value = true
        }
    }
    
    private func setAttributes() {
        title = "이슈"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: filterButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: selectButton)
        navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addViews() {

        view.addSubview(issueTableView)
        issueTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.width.height.equalTo(view.snp.width).multipliedBy(0.2)
        }
    }
}

extension TableViewDataSource where Model == IssueListTableViewCellModel,
                                    Cell == IssueListTableViewCell{
    
    static func create(models: [IssueListTableViewCellModel] = []) -> TableViewDataSource {
        return TableViewDataSource(models: models) { cell, model in
            cell.bind(to: model)
        }
    }
}

extension IssueListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.input.issueIndexSelected.value = indexPath.row
    }
}
