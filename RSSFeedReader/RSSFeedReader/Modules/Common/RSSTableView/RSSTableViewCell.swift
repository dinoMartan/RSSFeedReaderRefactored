//
//  HomeTableViewCell.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import UIKit
import PureLayout
import SkeletonView
import SDWebImage

class RSSTableViewCell: UITableViewCell {

    //MARK: - UIElements
    
    private let feedImageView: UIImageView = {
        let imageView = UIImageView.newAutoLayout()
        imageView.image = UIImage(named: "rss")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
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
        contentView.addSubview(nameDescriptionStackView)
        nameDescriptionStackView.addArrangedSubview(feedNameLabel)
        nameDescriptionStackView.addArrangedSubview(feedDescriptionLabel)
        
        feedImageView.autoSetDimensions(to: CGSize(width: 70, height: 70))
        feedImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        feedImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        nameDescriptionStackView.autoPinEdge(.left, to: .right, of: feedImageView, withOffset: 10)
        nameDescriptionStackView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        nameDescriptionStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        nameDescriptionStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        
        feedNameLabel.autoPinEdge(.left, to: .left, of: nameDescriptionStackView, withOffset: 0)
        feedNameLabel.autoPinEdge(.right, to: .right, of: nameDescriptionStackView, withOffset: 0)
        
        feedDescriptionLabel.autoPinEdge(.left, to: .left, of: nameDescriptionStackView, withOffset: 0)
        feedDescriptionLabel.autoPinEdge(.right, to: .right, of: nameDescriptionStackView, withOffset: 0)
        
        self.isSkeletonable = true
        contentView.setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public properties
    
    static let identifier = "RSSTableViewCell"
    
    //MARK: - Public methods
    
    func configureCell(feed: RSS) {
        setImage(imageUrl: feed.channel.image?.url, feedImage: nil)
        setNameLabel(text: feed.channel.title)
        setDescriptionLabel(text: feed.channel.description)
    }
    
    func configureCell(item: Item, feedImage: String?) {
        setImage(imageUrl: item.image?.url, feedImage: feedImage)
        setNameLabel(text: item.title)
        setDescriptionLabel(text: item.description)
    }
    
    func configureCell(result: Result) {
        setImage(imageUrl: result.iconURL, feedImage: nil)
        setNameLabel(text: result.title)
        setDescriptionLabel(text: result.resultDescription)
    }
    
    //MARK: - Private methods
    
    private func setImage(imageUrl: String?, feedImage: String?) {
        if let image = imageUrl ?? feedImage {
            feedImageView.sd_setImage(with: URL(string: image), completed: nil)
        }
        else {
            feedImageView.image = UIImage(named: "rss")
        }
    }
    
    private func setNameLabel(text: String?) {
        feedNameLabel.text = text ?? "NA"
    }
    
    private func setDescriptionLabel(text: String?) {
        feedDescriptionLabel.text = text ?? "N/A"
    }
    
}

