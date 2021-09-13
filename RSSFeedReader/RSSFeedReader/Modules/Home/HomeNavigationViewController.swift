//
//  HomeNavigationViewController.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 02/09/2021.
//

import UIKit

class HomeNavigationViewController: UINavigationController {
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeViewController = HomeViewController()
        viewControllers = [homeViewController]
    }

}
