//
//  RSSSearchViewControllerDelegate.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 04/09/2021.
//

import Foundation

protocol RSSSearchViewControllerDelegate: AnyObject {
    
    func didAddFeed(feedUrl: String)
    
}
