//
//  HomeTableViewCell.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import UIKit
import SDWebImage

class RSSTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet private weak var feedImageView: UIImageView!
    @IBOutlet private weak var feedNameLabel: UILabel!
    @IBOutlet private weak var feedDescriptionLabel: UILabel!
    @IBOutlet private weak var nameDescriptionStackView: UIStackView!
    
    //MARK: - Public properties
    
    static let identifier = "RSSTableViewCell"
    
    override func didMoveToSuperview() {
        feedImageView.layer.cornerRadius = feedImageView.frame.height / 2
    }
    
    //MARK: - Public methods
    
    func configureCell(feed: RSS) {
        if let image = feed.channel.image?.url {
            feedImageView.sd_setImage(with: URL(string: image), completed: nil)
        }
        else {
            feedImageView.image = UIImage(named: "rss")
        }
        feedImageView.layer.cornerRadius = feedImageView.frame.height / 2
        nameDescriptionStackView.distribution = .fill
        feedNameLabel.text = feed.channel.title ?? "N/A"
        feedDescriptionLabel.text = feed.channel.description ?? "N/A"
    }
    
    func configureCell(item: Item, feedImage: String?) {
        nameDescriptionStackView.distribution = .fill
        if let image = item.image?.url ?? feedImage {
            feedImageView.sd_setImage(with: URL(string: image), completed: nil)
        }
        else {
            feedImageView.image = UIImage(named: "rss")
        }
        feedNameLabel.text = item.title ?? "N/A"
        feedDescriptionLabel.text = item.description ?? "N/A"
    }
    
    func configureCell(result: Result) {
        feedImageView.layer.cornerRadius = feedImageView.frame.height / 2
        nameDescriptionStackView.distribution = .fill
        if let image = result.iconURL {
            feedImageView.sd_setImage(with: URL(string: image), completed: nil)
        }
        else {
            feedImageView.image = UIImage(named: "rss")
        }
        feedNameLabel.text = result.title
        feedDescriptionLabel.text = result.resultDescription ?? "N/A"
    }
    
}
