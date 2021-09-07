//
//  TestingViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 07/09/2021.
//

import UIKit
import PureLayout

class TestingViewController: UIViewController {
    
    //MARK: - UIElements
    
    private let imageView: UIImageView = {
        let imageView = UIImageView.newAutoLayout()
        imageView.image = UIImage(named: "rss")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel.newAutoLayout()
        label.text = "Hello world"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton.newAutoLayout()
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView.newAutoLayout()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private var didSetupConstraints = false
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .alizarin
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            imageView.autoSetDimension(.height, toSize: 150)
            imageView.autoSetDimension(.width, toSize: 150)
            
            button.autoSetDimensions(to: CGSize(width: 100, height: 35))

            stackView.autoPinEdge(toSuperviewEdge: .right, withInset: 30)
            stackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 30)
            
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    @objc func buttonTapped(sender: UIButton!) {
              print("Button Tapped")
         }

}
