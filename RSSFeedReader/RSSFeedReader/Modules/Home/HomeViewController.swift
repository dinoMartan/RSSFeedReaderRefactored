//
//  HomeViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import UIKit
import PureLayout
import SkeletonView

enum FeedsState {
    
    case noFeeds
    case ok
    
}

class HomeViewController: UIViewController {
    
    //MARK: - UIElements
    
    private let tableView: UITableView = {
        let tableView = UITableView.newAutoLayout()
        tableView.register(RSSTableViewCell.self, forCellReuseIdentifier: RSSTableViewCell.identifier)
        tableView.rowHeight = 120
        tableView.estimatedRowHeight = 120
        tableView.isSkeletonable = true
        return tableView
    }()
    
    private let noFeedsView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .systemBackground
        view.isHidden = true
        return view
    }()
    
    private let noFeedsViewLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.text = "No feeds!"
        return label
    }()
    
    private let addNewFeedButtonView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let addNewFeedButton: UIButton = {
        let button = UIButton.newAutoLayout()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapAddNewFeedButton), for: .touchUpInside)
        return button
    }()
    
    private var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        title = "RSS Feeds"
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(didTapSearchButton)
        )
        navigationItem.rightBarButtonItem = searchButton
        
        view.addSubview(tableView)
        
        view.addSubview(noFeedsView)
        noFeedsView.addSubview(noFeedsViewLabel)
        
        view.addSubview(addNewFeedButtonView)
        addNewFeedButtonView.addSubview(addNewFeedButton)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            didSetupConstraints = true
            
            tableView.autoPinEdgesToSuperviewSafeArea(with: .zero)
            
            noFeedsView.autoPinEdgesToSuperviewSafeArea(with: .zero)
            
            noFeedsViewLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
            noFeedsViewLabel.autoAlignAxis(toSuperviewAxis: .vertical)
            
            addNewFeedButton.autoAlignAxis(toSuperviewAxis: .horizontal)
            addNewFeedButton.autoAlignAxis(toSuperviewAxis: .vertical)
            
            addNewFeedButtonView.autoSetDimensions(to: CGSize(width: 50, height: 50))
            addNewFeedButtonView.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
            addNewFeedButtonView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 30)
        }
        super.updateViewConstraints()
    }
    
    //MARK: - Public properties
    
    //MARK: - Private properties
    
    private var viewModel = HomeViewModel()
    private var isInitialLoading = true
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Private extension -

private extension HomeViewController {
    
    //MARK: - UI Configuration
    
    private func setNoFeedsView(state: FeedsState) {
        if isInitialLoading {
            isInitialLoading = false
        }
        else {
            switch state {
            case .noFeeds:
                noFeedsView.isHidden = false
            case .ok:
                noFeedsView.isHidden = true
            }
        }
    }
    
    //MARK: - View Setup
    
    private func setupView() {
        configureTableView()
        fetchMyRssFeeds()
        bindData()
    }
    
    //MARK: - TableView Configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - Data
    
    private func bindData() {
        viewModel.feeds.bind { [unowned self] myFeeds in
            tableView.reloadData()
            if myFeeds.isEmpty { setNoFeedsView(state: .noFeeds) }
            else { setNoFeedsView(state: .ok) }
        }
    }
    
    private func fetchMyRssFeeds() {
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .rssGradient1, secondaryColor: .rssGrafient2), animation: .none, transition: .crossDissolve(1))
        viewModel.fetchMyRssFeeds {
            self.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(1))
        }
    }
    
    private func addNewFeed(feedUrl: String) {
        viewModel.addNewFeed(feedUrl: feedUrl) {
        } failure: { error in
            let alerter = Alerter(title: .defaultTitle, error: error, preferredStyle: .alert)
            alerter.addAction(title: .ok, style: .default, handler: nil)
            alerter.showAlert(on: self, completion: nil)
        }
    }
    
}

//MARK: - TableView DataSource and Delegate -

extension HomeViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    
    //MARK: - TableView NumberOfRows and CellForRow
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feeds.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RSSTableViewCell.identifier) as? RSSTableViewCell else {
            return UITableViewCell()
        }
        let myRSSFeed = viewModel.feeds.value[indexPath.row]
        cell.configureCell(feed: myRSSFeed.feed)
        return cell
    }
    
    //MARK: - TableView Selection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rssItemsStoryboard = UIStoryboard(name: "RSSItems", bundle: nil)
        guard let rssItemsViewController = rssItemsStoryboard.instantiateViewController(identifier: RSSItemsViewController.identifier) as? RSSItemsViewController else { return }
        let currentFeed = viewModel.feeds.value[indexPath.row]
        let rssItems = currentFeed.feed.channel.items
        let feedImage = currentFeed.feed.channel.image?.url
        rssItemsViewController.setItems(items: rssItems)
        rssItemsViewController.setFeedImage(image: feedImage)
        navigationController?.pushViewController(rssItemsViewController, animated: true)
    }
    
    //MARK: - SkeletonView
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return RSSTableViewCell.identifier
    }
    
    //MARK: - Row/feed deletion
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alerter = Alerter(title: .deleteFeedQuestion, message: .actionCannotBeUndone, preferredStyle: .actionSheet)
            alerter.addAction(title: .ok, style: .destructive) { [unowned self] _ in
                removeFeed(at: indexPath)
            }
            alerter.addAction(title: .cancel, style: .cancel, handler: nil)
            alerter.showAlert(on: self, completion: nil)
        }
    }
    
    //MARK: - Helper methods
    
    func removeFeed(at indexPath: IndexPath) {
        if viewModel.removeFeed(at: indexPath) {
            tableView.reloadData()
        }
        else {
            let alerter = Alerter(title: .defaultTitle, message: .defaultMessage, preferredStyle: .alert)
            alerter.addAction(title: .ok, style: .default, handler: nil)
            alerter.addAction(title: .cancel, style: .cancel, handler: nil)
            alerter.showAlert(on: self, completion: nil)
        }
    }
    
}

//MARK: - NewFeedViewControllerDelegate -

extension HomeViewController: NewFeedViewControllerDelegate {
    
    func didAddNewFeed(feedUrl: String) {
        addNewFeed(feedUrl: feedUrl)
    }
    
}

//MARK: - RSSSearchViewControllerDelegate -

extension HomeViewController: RSSSearchViewControllerDelegate {
    
    func didAddFeed(feedUrl: String) {
        addNewFeed(feedUrl: feedUrl)
    }
    
}

//MARK: - IBActions -

extension HomeViewController {
    
    @objc private func didTapAddNewFeedButton(_ sender: Any) {
        let newFeedStoryboard = UIStoryboard.init(name: "NewFeed", bundle: nil)
        guard let newFeedViewController = newFeedStoryboard.instantiateViewController(identifier: NewFeedViewController.identifier) as? NewFeedViewController else { return }
        newFeedViewController.delegate = self
        present(newFeedViewController, animated: true, completion: nil)
    }
    
    @objc private func didTapSearchButton(_ sender: Any) {
        let searchStoryboard = UIStoryboard(name: "RSSSearch", bundle: nil)
        guard let searchViewController = searchStoryboard.instantiateViewController(identifier: RSSSearchViewController.identifier) as? RSSSearchViewController else { return }
        searchViewController.delegate = self
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
}
