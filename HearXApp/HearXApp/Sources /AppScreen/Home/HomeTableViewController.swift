import UIKit

class HomeTableViewController: NiblessTableViewController {
    // MARK: internally exposed properties
    var didPressStart: (() -> Void)?
    
    // MARK: private objecs
    private enum HomeTableViewControllerRowIdentifier: CaseIterable {
        case titleDescription
        case startButton
    }
    
    // MARK: Tableview Controller Life Cycle
    override init() { super.init() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        registerCells()
    }
    
    // MARK: Helper functions
    private func setup() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        title = screentitle
        setupTableView()
    }
    
    private func registerCells() {
        tableView.register(TitleDescriptionTableViewCell.nib, forCellReuseIdentifier: TitleDescriptionTableViewCell.reusableIdentifier)
        tableView.register(CircularButtonTableViewCell.nib, forCellReuseIdentifier: CircularButtonTableViewCell.reusableIdentifier)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        //tableView.isScrollEnabled = false
    }
}

// MARK: - Table view data source

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { HomeTableViewControllerRowIdentifier.allCases.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch HomeTableViewControllerRowIdentifier.allCases[indexPath.row] {
        case .titleDescription:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleDescriptionTableViewCell.reusableIdentifier) as? TitleDescriptionTableViewCell else { fatalError() }
           let configData = TitleDescriptionTableViewCell.TitleDescriptionCellConfigurationDTO(title: "HearX App", description: descriptionText)
            cell.configure((configData, nil))
            return cell
        case .startButton:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CircularButtonTableViewCell.reusableIdentifier) as? CircularButtonTableViewCell else { fatalError() }
            cell.buttonActionBlock = { [weak self] in self?.didPressStart?() }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch HomeTableViewControllerRowIdentifier.allCases[indexPath.row] {
        case .titleDescription:
            return  UITableView.automaticDimension
        case .startButton:
            return Constants.Metrics.cellHeight500
        }
    }
}

// MARK: - Strings

private extension HomeTableViewController {
    var screentitle: String { localizedString(forKey: "homeScreenTitle") }
    var descriptionText: String { localizedString(forKey: "descriptionText") }
}
