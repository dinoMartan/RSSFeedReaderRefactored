//
//  RefactoredTableViewCell.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 08/09/2021.
//

import UIKit
import PureLayout
import SkeletonView

class RefactoredTableViewCell: UITableViewCell {

    //MARK: - UIElements
    
    private let feedImageView: UIImageView = {
        let imageView = UIImageView.newAutoLayout()
        imageView.image = UIImage(named: "rss")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private let feedNameLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.text = "Feed name"
        label.font = UIFont(name: "Arial", size: 17)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.isSkeletonable = true
        return label
    }()
    
    private let feedDescriptionLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.text = "Description"
        label.font = UIFont(name: "Arial", size: 14)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.isSkeletonable = true
        return label
    }()
    
    private let nameDescriptionStackView: UIStackView = {
        let stackView = UIStackView.newAutoLayout()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.isSkeletonable = true
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(feedImageView)
        contentView.addSubview(feedNameLabel)
        contentView.addSubview(feedDescriptionLabel)

        setNeedsUpdateConfiguration()
        
        feedImageView.autoSetDimensions(to: CGSize(width: 70, height: 70))
        feedImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        feedImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        feedNameLabel.autoPinEdge(.left, to: .right, of: feedImageView, withOffset: 10)
        feedNameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        feedNameLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)

        feedDescriptionLabel.autoPinEdge(.top, to: .bottom, of: feedNameLabel, withOffset: 10)
        feedDescriptionLabel.autoPinEdge(.left, to: .right, of: feedImageView, withOffset: 10)
        feedDescriptionLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        feedDescriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        
        self.isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public properties
    
    static let identifier = "RSSTableViewCell"
    
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
