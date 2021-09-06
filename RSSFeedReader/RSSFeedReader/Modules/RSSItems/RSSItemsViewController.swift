//
//  RSSItemsViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 02/09/2021.
//

import UIKit
import SafariServices

class RSSItemsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Public properties
    
    static let identifier = "RSSItemsViewController"
    
    //MARK: - Private properties
    
    private var viewModel = RSSItemViewModel()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

//MARK: - Public extension -

extension RSSItemsViewController {
    
    func setItems(items: [Item]?) {
        viewModel.items = items
    }
    
    func setFeedImage(image: String?) {
        viewModel.feedImage = image
    }
    
}

//MARK: - Private extension -

private extension RSSItemsViewController {
    
    //MARK: - View Setup
    
    private func setupView() {
        if viewModel.items != nil {
            configureTableView()
        }
        else { dismiss(animated: true, completion: nil) }
    }
    
    //MARK: - TableView Configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: RSSTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RSSTableViewCell.identifier)
    }
    
}

//MARK: - TableView DataSource and Delegate -

extension RSSItemsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - NumberOfRows and CellForRow
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = viewModel.items { return items.count }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RSSTableViewCell.identifier) as? RSSTableViewCell,
              let items = viewModel.items else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.configureCell(item: item, feedImage: viewModel.feedImage)
        return cell
    }
    
    //MARK: - Table Height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //MARK: - Selection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let items = viewModel.items,
              let itemLink = items[indexPath.row].link,
              let url = URL(string: itemLink)
        else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
}
