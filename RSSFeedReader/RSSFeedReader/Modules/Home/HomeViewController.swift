//
//  HomeViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import UIKit
import SkeletonView

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addNewFeedButton: UIButton!
    @IBOutlet private weak var noFeedsView: UIView!
    
    //MARK: - Public properties
    
    static let identifier = "HomeViewController"
    
    //MARK: - Private properties
    
    private var viewModel = HomeViewModel()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureUI()
    }
    
}

//MARK: - Private extension -

private extension HomeViewController {
    
    //MARK: - UI Configuration
    
    private func configureUI() {
        addNewFeedButton.layer.cornerRadius = addNewFeedButton.frame.height / 2
    }
    
    private func setNoFeedsView() {
        if viewModel.feeds.isEmpty { noFeedsView.isHidden = false }
        else { noFeedsView.isHidden = true }
    }
    
    //MARK: - View Setup
    
    private func setupView() {
        configureTableView()
        fetchMyRssFeeds()
    }
    
    //MARK: - TableView Configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: RSSTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RSSTableViewCell.identifier)
    }
    
    //MARK: - Data
    
    private func fetchMyRssFeeds() {
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .rssGradient1, secondaryColor: .rssGrafient2), animation: .none, transition: .crossDissolve(1))
        viewModel.fetchMyRssFeeds {
            self.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(1))
            self.setNoFeedsView()
        }
    }
    
    private func addNewFeed(feedUrl: String) {
        viewModel.addNewFeed(feedUrl: feedUrl) {
            self.tableView.reloadData()
            self.setNoFeedsView()
        } failure: { [unowned self] error in
            let alerter = Alerter(title: .defaultTitle, error: error, preferredStyle: .alert)
            alerter.addAction(title: .ok, style: .default, handler: nil)
            alerter.addAction(title: .cancel, style: .cancel, handler: nil)
            alerter.showAlert(on: self, completion: nil)
            setNoFeedsView()
        }
    }
    
}

//MARK: - TableView DataSource and Delegate -

extension HomeViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    
    //MARK: - TableView NumberOfRows and CellForRow
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RSSTableViewCell.identifier) as? RSSTableViewCell else {
            return UITableViewCell()
        }
        let myRSSFeed = viewModel.feeds[indexPath.row]
        cell.configureCell(feed: myRSSFeed.feed)
        return cell
    }
    
    //MARK: - TableView Selection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rssItemsStoryboard = UIStoryboard(name: "RSSItems", bundle: nil)
        guard let rssItemsViewController = rssItemsStoryboard.instantiateViewController(identifier: RSSItemsViewController.identifier) as? RSSItemsViewController else { return }
        let currentFeed = viewModel.feeds[indexPath.row]
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
            setNoFeedsView()
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
    
    @IBAction func didTapAddNewFeedButton(_ sender: Any) {
        let newFeedStoryboard = UIStoryboard.init(name: "NewFeed", bundle: nil)
        guard let newFeedViewController = newFeedStoryboard.instantiateViewController(identifier: NewFeedViewController.identifier) as? NewFeedViewController else { return }
        newFeedViewController.delegate = self
        present(newFeedViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        let searchStoryboard = UIStoryboard(name: "RSSSearch", bundle: nil)
        guard let searchViewController = searchStoryboard.instantiateViewController(identifier: RSSSearchViewController.identifier) as? RSSSearchViewController else { return }
        searchViewController.delegate = self
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
}
