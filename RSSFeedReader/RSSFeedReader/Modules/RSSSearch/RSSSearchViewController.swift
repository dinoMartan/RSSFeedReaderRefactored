//
//  RSSSearchViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 03/09/2021.
//

import UIKit
import SkeletonView
import SafariServices
import PureLayout

class RSSSearchViewController: UIViewController {
    
    //MARK: - UI Elements
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar.newAutoLayout()
        searchBar.searchBarStyle = .default
        searchBar.placeholder = "Search RSS Feeds"
        searchBar.isTranslucent = false
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView.newAutoLayout()
        tableView.register(RSSTableViewCell.self, forCellReuseIdentifier: RSSTableViewCell.identifier)
        tableView.rowHeight = 120
        tableView.estimatedRowHeight = 120
        tableView.isSkeletonable = true
        return tableView
    }()
    
    private var didUpdateViewConstraints = false
    
    override func loadView() {
        view = UIView()
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !didUpdateViewConstraints {
            didUpdateViewConstraints = true

            searchBar.autoSetDimension(.width, toSize: view.frame.width)
            searchBar.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
            
            tableView.autoPinEdge(.top, to: .bottom, of: searchBar, withOffset: 0)
            tableView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            tableView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            tableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        }
        super.updateViewConstraints()
    }
    
    //MARK: - Public properties
    
    weak var delegate: RSSSearchViewControllerDelegate?
    
    //MARK: - Private properties
    
    private var viewModel = RSSSearchViewModel()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extension -

private extension RSSSearchViewController {
    
    //MARK: - View Setup
    
    private func setupView() {
        configureTableView()
        configureSearchBar()
        bindData()
    }
    
    //MARK: - TableView Configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - SearchBar Configuration
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    //MARK: - Data
    
    private func fetchData(query: String) {
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .rssGradient1, secondaryColor: .rssGrafient2), animation: .none, transition: .crossDissolve(1))
        viewModel.fetchData(query: query) {
            self.tableView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(1.0))
        } failure: { error in
            let alerter = Alerter(title: .defaultTitle, error: error, preferredStyle: .alert)
            alerter.addAction(title: .ok, style: .default) { [unowned self] _ in
                tableView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(1.0))
            }
            alerter.addAction(title: .cancel, style: .cancel, handler: nil)
            alerter.showAlert(on: self, completion: nil)
        }
    }
    
    private func bindData() {
        viewModel.searchResult.bind { [unowned self] _ in
            tableView.reloadData()
        }
    }
    
}

//MARK: - TableView DataSource and Delegate -

extension RSSSearchViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    
    //MARK: - NumberOfRows and CellForRow
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = viewModel.searchResult.value?.results else { return 0 }
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RSSTableViewCell.identifier) as? RSSTableViewCell,
              let results = viewModel.searchResult.value?.results
        else { return UITableViewCell() }
        let result = results[indexPath.row]
        cell.configureCell(result: result)
        return cell
    }
    
    //MARK: - SkeletonView
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return RSSTableViewCell.identifier
    }
    
    //MARK: - Selection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let results = viewModel.searchResult.value?.results,
              let website = results[indexPath.row].website,
              let url = URL(string: website)
              else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    //MARK: - Swipe actions
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let results = viewModel.searchResult.value?.results,
              let feedUrl = results[indexPath.row].feedID
        else { return nil }
        let action = UIContextualAction(style: .normal, title: AlertButtonConstants.addFeed.rawValue) { [unowned self] (_, _, completionHandler) in
            completionHandler(true)
            addNewFeed(feedUrl: feedUrl)
        }
        action.backgroundColor = .rssGradient1
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //MARK: - Helper methods
    
    private func addNewFeed(feedUrl: String) {
        viewModel.addNewFeed(feedUrl: feedUrl) { [unowned self] url in
            let alerter = Alerter(title: .feedAdded, message: nil, preferredStyle: .actionSheet)
            alerter.addAction(title: .ok, style: .default, handler: nil)
            alerter.showAlert(on: self, completion: nil)
            delegate?.didAddFeed(feedUrl: url)
        } feedExists: {
            let alerter = Alerter(title: .feedExitsts, message: .feedAlreadyAdded, preferredStyle: .alert)
            alerter.addAction(title: .ok, style: .default, handler: nil)
            alerter.showAlert(on: self, completion: nil)
        }
    }
    
}

//MARK: - SearchBar Delegate -

extension RSSSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text,
           text != "" {
            fetchData(query: text)
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
