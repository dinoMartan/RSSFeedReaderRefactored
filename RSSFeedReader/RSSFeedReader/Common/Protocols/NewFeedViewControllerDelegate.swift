//
//  NewFeedDelegate.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import Foundation

protocol NewFeedViewControllerDelegate: AnyObject {
    
    func didAddNewFeed(feedUrl: String)
    
}
